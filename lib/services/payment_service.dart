import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class PaymentService {
  static final _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // ─── Initialization ──────────────────────────────────────────────────────────
  /// Call once in main() before runApp
  static Future<void> init({required String publishableKey}) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  // ─── Create Payment Intent (Backend Call) ────────────────────────────────────
  /// Calls the Firebase Cloud Function / backend to create a Stripe PaymentIntent.
  /// Returns the client_secret needed for the payment sheet.
  static Future<String?> _createPaymentIntent({
    required int amountInHalala, // smallest currency unit (SAR × 100)
    required String currency,
    required String orderId,
    String? customerId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/payments/create-intent',
        data: {
          'amount': amountInHalala,
          'currency': currency.toLowerCase(),
          'orderId': orderId,
          if (customerId != null) 'customerId': customerId,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['clientSecret'] as String?;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('PaymentService._createPaymentIntent error: ${e.message}');
      return null;
    }
  }

  // ─── Process Payment via Payment Sheet ──────────────────────────────────────
  /// Full payment flow:
  /// 1. Creates a PaymentIntent on the backend
  /// 2. Initialises the Stripe Payment Sheet
  /// 3. Presents the Payment Sheet to the user
  ///
  /// Returns [PaymentResult] with success flag and optional error message.
  static Future<PaymentResult> processPayment({
    required double amount,          // in SAR
    required String currency,
    required String orderId,
    required String merchantName,
    String? customerId,
    String? customerEmail,
  }) async {
    try {
      final amountInHalala = (amount * 100).round();

      // Step 1 — create payment intent on backend
      final clientSecret = await _createPaymentIntent(
        amountInHalala: amountInHalala,
        currency: currency,
        orderId: orderId,
        customerId: customerId,
      );

      if (clientSecret == null) {
        return PaymentResult.failure('فشل في إنشاء طلب الدفع. حاول مجدداً.');
      }

      // Step 2 — initialise payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantName,
          customerId: customerId,
          customerEphemeralKeySecret: null, // set if using saved cards
          billingDetails: customerEmail != null
              ? BillingDetails(email: customerEmail)
              : null,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFFFF6B00),
            ),
          ),
          style: ThemeMode.system,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'SA',
            currencyCode: 'SAR',
            testEnv: true,
          ),
        ),
      );

      // Step 3 — present payment sheet
      await Stripe.instance.presentPaymentSheet();

      return PaymentResult.success(clientSecret: clientSecret);
    } on StripeException catch (e) {
      final msg = e.error.localizedMessage ?? e.error.message ?? 'خطأ في الدفع';
      debugPrint('PaymentService StripeException: $msg');
      return PaymentResult.failure(msg);
    } catch (e) {
      debugPrint('PaymentService unexpected error: $e');
      return PaymentResult.failure('حدث خطأ غير متوقع. حاول مجدداً.');
    }
  }

  // ─── Refund ──────────────────────────────────────────────────────────────────
  /// Requests a refund for an order via the backend.
  static Future<bool> requestRefund({
    required String orderId,
    required String paymentIntentId,
    double? amount, // partial refund amount in SAR; null = full refund
  }) async {
    try {
      final data = <String, dynamic>{
        'orderId': orderId,
        'paymentIntentId': paymentIntentId,
        if (amount != null) 'amount': (amount * 100).round(),
      };

      final response = await _dio.post(
        '/api/v1/payments/refund',
        data: data,
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('PaymentService.requestRefund error: ${e.message}');
      return false;
    }
  }

  // ─── Validate Card (Tokenise) ────────────────────────────────────────────────
  /// Creates a Stripe token from raw card details (for display/validation only).
  /// Prefer the Payment Sheet for actual payments.
  static Future<String?> createCardToken({
    required String number,
    required int expMonth,
    required int expYear,
    required String cvc,
  }) async {
    try {
      final tokenData = await Stripe.instance.createToken(
        CreateTokenParams.card(
          params: CardTokenParams(
            type: TokenType.Card,
            // Card params handled securely inside the Stripe SDK
          ),
        ),
      );
      return tokenData.id;
    } on StripeException catch (e) {
      debugPrint('createCardToken error: ${e.error.message}');
      return null;
    }
  }
}

// ─── Payment Result ───────────────────────────────────────────────────────────
class PaymentResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? clientSecret;

  const PaymentResult._({
    required this.isSuccess,
    this.errorMessage,
    this.clientSecret,
  });

  factory PaymentResult.success({String? clientSecret}) => PaymentResult._(
        isSuccess: true,
        clientSecret: clientSecret,
      );

  factory PaymentResult.failure(String message) => PaymentResult._(
        isSuccess: false,
        errorMessage: message,
      );

  @override
  String toString() =>
      'PaymentResult(success=$isSuccess, error=$errorMessage)';
}
