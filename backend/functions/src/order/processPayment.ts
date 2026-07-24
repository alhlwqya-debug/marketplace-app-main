import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const stripe = require('stripe')(functions.config().stripe.secret);

export const processPayment = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { orderId, paymentMethodId } = data;

  try {
    const orderDoc = await admin.firestore().collection('orders').doc(orderId).get();
    if (!orderDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Order not found');
    }

    const order = orderDoc.data();

    // Create payment intent
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(order!.total * 100), // Convert to cents
      currency: 'sar',
      payment_method: paymentMethodId,
      confirm: true,
      automatic_payment_methods: {
        enabled: true,
        allow_redirects: 'never',
      },
    });

    // Update order status
    await admin.firestore().collection('orders').doc(orderId).update({
      paymentStatus: paymentIntent.status === 'succeeded' ? 'paid' : 'failed',
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      success: paymentIntent.status === 'succeeded',
      paymentIntentId: paymentIntent.id,
    };
  } catch (error: any) {
    throw new functions.https.HttpsError('internal', error.message);
  }
});
