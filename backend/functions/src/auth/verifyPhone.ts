import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Verifies a phone number via OTP using Firebase Auth.
 * Called from the Flutter app after the user enters their OTP.
 */
export const verifyPhone = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'يجب تسجيل الدخول أولاً',
    );
  }

  const { phoneNumber } = data as { phoneNumber: string };

  if (!phoneNumber) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'رقم الهاتف مطلوب',
    );
  }

  // Normalise phone number (ensure +966 prefix for Saudi numbers)
  const normalised = normalisePhone(phoneNumber);

  try {
    // Update user's phone number in Firebase Auth
    await admin.auth().updateUser(context.auth.uid, {
      phoneNumber: normalised,
    });

    // Mark phone as verified in Firestore
    await admin.firestore()
      .collection('users')
      .doc(context.auth.uid)
      .update({
        phone: normalised,
        phoneVerified: true,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    functions.logger.info(`Phone verified for user ${context.auth.uid}: ${normalised}`);

    return { success: true, phone: normalised };
  } catch (error: any) {
    functions.logger.error('verifyPhone error:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message ?? 'فشل في التحقق من رقم الهاتف',
    );
  }
});

function normalisePhone(phone: string): string {
  // Strip spaces and dashes
  let cleaned = phone.replace(/[\s\-()]/g, '');

  // Add Saudi country code if missing
  if (cleaned.startsWith('05')) {
    cleaned = '+966' + cleaned.slice(1);
  } else if (cleaned.startsWith('5') && cleaned.length === 9) {
    cleaned = '+966' + cleaned;
  }

  return cleaned;
}
