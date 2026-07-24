import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();
const messaging = admin.messaging();

/**
 * Runs every hour to send scheduled reminder notifications:
 * - Abandoned cart reminders (cart idle > 24h)
 * - Order status follow-ups (order pending > 48h)
 * - Re-engagement for users inactive > 7 days
 */
export const scheduleReminders = functions.pubsub
  .schedule('every 60 minutes')
  .onRun(async (_context) => {
    const now = admin.firestore.Timestamp.now();

    await Promise.allSettled([
      sendAbandonedCartReminders(now),
      sendPendingOrderReminders(now),
      sendReEngagementReminders(now),
    ]);

    return null;
  });

// ─── Abandoned Cart Reminders ─────────────────────────────────────────────────
async function sendAbandonedCartReminders(
  now: admin.firestore.Timestamp,
): Promise<void> {
  const threshold24h = new admin.firestore.Timestamp(
    now.seconds - 24 * 3600,
    0,
  );

  const snapshot = await db
    .collection('carts')
    .where('updatedAt', '<', threshold24h)
    .where('reminderSent', '==', false)
    .limit(100)
    .get();

  if (snapshot.empty) return;

  const batch = db.batch();
  const messages: admin.messaging.Message[] = [];

  for (const doc of snapshot.docs) {
    const cart = doc.data();
    if (!cart.items?.length) continue;

    const userDoc = await db.collection('users').doc(doc.id).get();
    const user = userDoc.data();
    if (!user?.fcmToken) continue;

    messages.push({
      token: user.fcmToken,
      notification: {
        title: '🛒 نسيت شيئاً في سلتك!',
        body: `لديك ${cart.items.length} منتج في سلتك. أكمل طلبك الآن.`,
      },
      data: {
        type: 'cart_reminder',
        userId: doc.id,
      },
      android: { priority: 'normal' },
      apns: { payload: { aps: { badge: 1 } } },
    });

    batch.update(doc.ref, { reminderSent: true });
  }

  if (messages.length > 0) {
    await messaging.sendEach(messages);
    functions.logger.info(`Sent ${messages.length} cart reminder(s)`);
  }

  await batch.commit();
}

// ─── Pending Order Reminders ──────────────────────────────────────────────────
async function sendPendingOrderReminders(
  now: admin.firestore.Timestamp,
): Promise<void> {
  const threshold48h = new admin.firestore.Timestamp(
    now.seconds - 48 * 3600,
    0,
  );

  const snapshot = await db
    .collection('orders')
    .where('status', '==', 'pending')
    .where('createdAt', '<', threshold48h)
    .limit(50)
    .get();

  if (snapshot.empty) return;

  const messages: admin.messaging.Message[] = [];

  for (const doc of snapshot.docs) {
    const order = doc.data();

    const [buyerDoc, storeDoc] = await Promise.all([
      db.collection('users').doc(order.buyerId).get(),
      db.collection('stores').doc(order.storeId).get(),
    ]);

    const buyer = buyerDoc.data();
    const store = storeDoc.data();

    // Notify buyer
    if (buyer?.fcmToken) {
      messages.push({
        token: buyer.fcmToken,
        notification: {
          title: '⏳ تحديث طلبك',
          body: `طلبك من ${store?.name ?? 'المتجر'} لا يزال قيد الانتظار.`,
        },
        data: { type: 'order_pending', orderId: doc.id },
      });
    }

    // Notify seller
    const storeOwnerDoc = store?.ownerId
      ? await db.collection('users').doc(store.ownerId).get()
      : null;
    const storeOwner = storeOwnerDoc?.data();

    if (storeOwner?.fcmToken) {
      messages.push({
        token: storeOwner.fcmToken,
        notification: {
          title: '📦 طلب ينتظر تأكيدك',
          body: `طلب #${doc.id.slice(-6)} ينتظر تأكيدك منذ أكثر من 48 ساعة.`,
        },
        data: { type: 'order_action_needed', orderId: doc.id },
      });
    }
  }

  if (messages.length > 0) {
    await messaging.sendEach(messages);
    functions.logger.info(`Sent ${messages.length} pending-order reminder(s)`);
  }
}

// ─── Re-engagement Reminders ──────────────────────────────────────────────────
async function sendReEngagementReminders(
  now: admin.firestore.Timestamp,
): Promise<void> {
  const threshold7d = new admin.firestore.Timestamp(
    now.seconds - 7 * 24 * 3600,
    0,
  );

  const snapshot = await db
    .collection('users')
    .where('lastActiveAt', '<', threshold7d)
    .where('reEngagementSentAt', '<', threshold7d) // avoid daily spam
    .limit(200)
    .get();

  if (snapshot.empty) return;

  const batch = db.batch();
  const messages: admin.messaging.Message[] = [];

  for (const doc of snapshot.docs) {
    const user = doc.data();
    if (!user.fcmToken) continue;

    messages.push({
      token: user.fcmToken,
      notification: {
        title: '👋 اشتقنا إليك!',
        body: 'اكتشف أحدث المنتجات والعروض في السوق التجاري.',
      },
      data: { type: 're_engagement' },
    });

    batch.update(doc.ref, {
      reEngagementSentAt: now,
    });
  }

  if (messages.length > 0) {
    await messaging.sendEach(messages);
    functions.logger.info(`Sent ${messages.length} re-engagement reminder(s)`);
  }

  await batch.commit();
}
