import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userRef = admin.firestore().collection('users').doc(user.uid);

  await userRef.set({
    uid: user.uid,
    email: user.email,
    phone: user.phoneNumber || '',
    displayName: user.displayName || 'مستخدم جديد',
    avatarUrl: user.photoURL,
    type: 'buyer',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    isVerified: user.emailVerified,
    fcmToken: null,
  });

  // Send welcome notification
  await admin.firestore().collection('notifications').add({
    userId: user.uid,
    title: 'مرحباً بك في السوق التجاري!',
    body: 'نحن سعداء بانضمامك إلينا. ابدأ التسوق الآن!',
    type: 'welcome',
    read: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
});
