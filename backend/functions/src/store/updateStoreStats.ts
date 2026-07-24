import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const updateStoreStats = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const oldData = change.before.data();

    // Only update when order is completed
    if (newData.status === 'delivered' && oldData.status !== 'delivered') {
      const storeId = newData.storeId;
      const orderTotal = newData.total;

      // Update store revenue
      await admin.firestore().collection('stores').doc(storeId).update({
        totalRevenue: admin.firestore.FieldValue.increment(orderTotal),
        totalOrders: admin.firestore.FieldValue.increment(1),
      });

      // Update store rating from reviews
      const reviewsSnapshot = await admin.firestore()
        .collection('reviews')
        .where('storeId', '==', storeId)
        .get();

      if (!reviewsSnapshot.empty) {
        const totalRating = reviewsSnapshot.docs.reduce((sum, doc) => sum + (doc.data().rating || 0), 0);
        const averageRating = totalRating / reviewsSnapshot.size;

        await admin.firestore().collection('stores').doc(storeId).update({
          rating: Math.round(averageRating * 10) / 10,
          reviewCount: reviewsSnapshot.size,
        });
      }
    }
  });
