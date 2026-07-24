import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const updateOrderStatus = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { orderId, status, trackingNumber } = data;

  const orderDoc = await admin.firestore().collection('orders').doc(orderId).get();
  if (!orderDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Order not found');
  }

  const order = orderDoc.data();
  const storeId = order?.storeId;

  // Verify store ownership
  const storeDoc = await admin.firestore().collection('stores').doc(storeId).get();
  if (!storeDoc.exists || storeDoc.data()?.ownerId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Not authorized');
  }

  const updateData: any = {
    status,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  if (trackingNumber) {
    updateData.trackingNumber = trackingNumber;
  }

  await admin.firestore().collection('orders').doc(orderId).update(updateData);

  // Notify buyer
  await admin.firestore().collection('notifications').add({
    userId: order?.buyerId,
    title: 'تحديث حالة الطلب',
    body: `تم تحديث حالة طلبك إلى: ${status}`,
    type: 'order_status',
    orderId,
    read: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true };
});
