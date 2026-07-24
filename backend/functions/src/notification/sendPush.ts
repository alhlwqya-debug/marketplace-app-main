import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const sendPush = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();

    if (!notification.userId || notification.read) {
      return null;
    }

    // Get user's FCM token
    const userDoc = await admin.firestore().collection('users').doc(notification.userId).get();
    if (!userDoc.exists) {
      return null;
    }

    const user = userDoc.data();
    const fcmToken = user?.fcmToken;

    if (!fcmToken) {
      return null;
    }

    // Send push notification
    const message = {
      token: fcmToken,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: {
        type: notification.type || 'general',
        notificationId: context.params.notificationId,
        ...(notification.orderId && { orderId: notification.orderId }),
      },
      android: {
        notification: {
          channelId: 'marketplace_channel',
          priority: 'high',
        },
      },
      apns: {
        payload: {
          aps: {
            badge: 1,
            sound: 'default',
          },
        },
      },
    };

    try {
      await admin.messaging().send(message);
      return { success: true };
    } catch (error) {
      console.error('Error sending push notification:', error);
      return { success: false, error };
    }
  });
