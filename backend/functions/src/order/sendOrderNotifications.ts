import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const sendOrderNotifications = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const order = snap.data();
    const orderId = context.params.orderId;

    // Notify buyer
    await admin.firestore().collection('notifications').add({
      userId: order.buyerId,
      title: 'تم تأكيد طلبك!',
      body: `طلبك رقم #${orderId.substring(0, 8)} قيد المعالجة`,
      type: 'order_confirmed',
      orderId,
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Notify store owner
    const storeDoc = await admin.firestore().collection('stores').doc(order.storeId).get();
    if (storeDoc.exists) {
      await admin.firestore().collection('notifications').add({
        userId: storeDoc.data()?.ownerId,
        title: 'طلب جديد!',
        body: `لديك طلب جديد بقيمة ${order.total} ر.س`,
        type: 'new_order',
        orderId,
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });
