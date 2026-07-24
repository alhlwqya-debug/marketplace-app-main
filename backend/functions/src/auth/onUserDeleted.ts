import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const batch = admin.firestore().batch();

  // Delete user data
  const userRef = admin.firestore().collection('users').doc(user.uid);
  batch.delete(userRef);

  // Delete user's cart
  const cartRef = admin.firestore().collection('carts').doc(user.uid);
  batch.delete(cartRef);

  // Delete user's notifications
  const notificationsSnapshot = await admin.firestore()
    .collection('notifications')
    .where('userId', '==', user.uid)
    .get();

  notificationsSnapshot.docs.forEach(doc => {
    batch.delete(doc.ref);
  });

  await batch.commit();
});
