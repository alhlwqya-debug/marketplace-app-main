import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const authenticateUser = async (context: functions.https.CallableContext) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  return context.auth.uid;
};

export const checkAdmin = async (uid: string) => {
  const userDoc = await admin.firestore().collection('users').doc(uid).get();
  if (!userDoc.exists || userDoc.data()?.type !== 'admin') {
    throw new functions.https.HttpsError('permission-denied', 'Admin access required');
  }
};

export const checkStoreOwner = async (storeId: string, uid: string) => {
  const storeDoc = await admin.firestore().collection('stores').doc(storeId).get();
  if (!storeDoc.exists || storeDoc.data()?.ownerId !== uid) {
    throw new functions.https.HttpsError('permission-denied', 'Store owner access required');
  }
};

export const checkProductOwner = async (productId: string, uid: string) => {
  const productDoc = await admin.firestore().collection('products').doc(productId).get();
  if (!productDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Product not found');
  }
  const storeId = productDoc.data()?.storeId;
  await checkStoreOwner(storeId, uid);
};

export const handleError = (error: any): functions.https.HttpsError => {
  console.error('Function error:', error);
  if (error instanceof functions.https.HttpsError) {
    return error;
  }
  return new functions.https.HttpsError('internal', error.message || 'Internal server error');
};
