import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const createProduct = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { 
    storeId, name, description, price, discountPrice, 
    images, category, subCategory, tags, inventory, variants 
  } = data;

  // Verify store ownership
  const storeDoc = await admin.firestore().collection('stores').doc(storeId).get();
  if (!storeDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Store not found');
  }

  const store = storeDoc.data();
  if (store!.ownerId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Not store owner');
  }

  // Create product
  const productRef = admin.firestore().collection('products').doc();
  const product = {
    productId: productRef.id,
    storeId,
    name,
    description,
    price,
    discountPrice: discountPrice || null,
    images: images || [],
    category,
    subCategory: subCategory || null,
    tags: tags || [],
    inventory,
    variants: variants || null,
    rating: 0,
    reviewCount: 0,
    isActive: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await productRef.set(product);

  // Update store product count
  await admin.firestore().collection('stores').doc(storeId).update({
    productCount: admin.firestore.FieldValue.increment(1),
  });

  return { productId: productRef.id };
});
