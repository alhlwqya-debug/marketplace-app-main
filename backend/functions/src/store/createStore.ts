import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const createStore = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { name, description, category, location } = data;
  const ownerId = context.auth.uid;

  // Check if user already has a store
  const existingStore = await admin.firestore()
    .collection('stores')
    .where('ownerId', '==', ownerId)
    .limit(1)
    .get();

  if (!existingStore.empty) {
    throw new functions.https.HttpsError('already-exists', 'User already has a store');
  }

  // Create store
  const storeRef = admin.firestore().collection('stores').doc();
  const store = {
    storeId: storeRef.id,
    ownerId,
    name,
    description,
    category,
    location: location || null,
    rating: 0,
    followersCount: 0,
    status: 'pending',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await storeRef.set(store);

  // Update user type to seller
  await admin.firestore().collection('users').doc(ownerId).update({
    type: 'seller',
  });

  return { storeId: storeRef.id, status: 'pending' };
});
