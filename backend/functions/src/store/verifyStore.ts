import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const verifyStore = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { storeId } = data;

  // Verify admin role
  const userDoc = await admin.firestore().collection('users').doc(context.auth.uid).get();
  if (!userDoc.exists || userDoc.data()?.type !== 'admin') {
    throw new functions.https.HttpsError('permission-denied', 'Admin access required');
  }

  // Update store status
  await admin.firestore().collection('stores').doc(storeId).update({
    status: 'active',
    verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
    verifiedBy: context.auth.uid,
  });

  // Notify store owner
  const storeDoc = await admin.firestore().collection('stores').doc(storeId).get();
  if (storeDoc.exists) {
    await admin.firestore().collection('notifications').add({
      userId: storeDoc.data()?.ownerId,
      title: 'تم قبول متجرك!',
      body: 'تهانينا! تم قبول متجرك وهو الآن متاح للمستخدمين.',
      type: 'store_verified',
      storeId,
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  return { success: true };
});
