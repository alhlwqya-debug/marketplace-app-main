import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const createOrder = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { items, shippingAddress, paymentMethod, storeId } = data;
  const buyerId = context.auth.uid;

  // Validate items
  if (!items || items.length === 0) {
    throw new functions.https.HttpsError('invalid-argument', 'Cart is empty');
  }

  // Calculate totals
  let subtotal = 0;
  for (const item of items) {
    const productDoc = await admin.firestore().collection('products').doc(item.productId).get();
    if (!productDoc.exists) {
      throw new functions.https.HttpsError('not-found', `Product ${item.productId} not found`);
    }

    const product = productDoc.data();
    if (product!.inventory < item.quantity) {
      throw new functions.https.HttpsError('failed-precondition', 
        `Insufficient inventory for product ${product!.name}`);
    }

    subtotal += (product!.discountPrice || product!.price) * item.quantity;
  }

  const shippingCost = 15; // Fixed shipping cost
  const total = subtotal + shippingCost;

  // Create order
  const orderRef = admin.firestore().collection('orders').doc();
  const order = {
    orderId: orderRef.id,
    buyerId,
    storeId,
    items: items.map((item: any) => ({
      productId: item.productId,
      productName: item.productName,
      productImage: item.productImage,
      price: item.price,
      quantity: item.quantity,
      selectedVariants: item.selectedVariants || null,
    })),
    status: 'pending',
    subtotal,
    shippingCost,
    total,
    paymentMethod,
    paymentStatus: 'pending',
    shippingAddress,
    trackingNumber: null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await orderRef.set(order);

  // Update inventory
  const batch = admin.firestore().batch();
  for (const item of items) {
    const productRef = admin.firestore().collection('products').doc(item.productId);
    batch.update(productRef, {
      inventory: admin.firestore.FieldValue.increment(-item.quantity),
    });
  }
  await batch.commit();

  // Send notification to store owner
  const storeDoc = await admin.firestore().collection('stores').doc(storeId).get();
  if (storeDoc.exists) {
    const store = storeDoc.data();
    await admin.firestore().collection('notifications').add({
      userId: store!.ownerId,
      title: 'طلب جديد!',
      body: `لديك طلب جديد بقيمة ${total} ر.س`,
      type: 'new_order',
      orderId: orderRef.id,
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  // Clear cart
  await admin.firestore().collection('carts').doc(buyerId).delete();

  return { orderId: orderRef.id, total };
});
