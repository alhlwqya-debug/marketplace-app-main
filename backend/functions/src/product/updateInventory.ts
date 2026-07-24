import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const updateInventory = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { productId, quantity } = data;

  // Verify product ownership
  const productDoc = await admin.firestore().collection('products').doc(productId).get();
  if (!productDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Product not found');
  }

  const storeId = productDoc.data()?.storeId;
  const storeDoc = await admin.firestore().collection('stores').doc(storeId).get();

  if (!storeDoc.exists || storeDoc.data()?.ownerId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Not product owner');
  }

  // Update inventory
  await admin.firestore().collection('products').doc(productId).update({
    inventory: admin.firestore.FieldValue.increment(quantity),
  });

  return { success: true, newInventory: productDoc.data()?.inventory + quantity };
});
