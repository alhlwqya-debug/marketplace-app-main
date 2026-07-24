import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  static Future<void> logAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) async {
    await _analytics.logEvent(
      name: 'add_to_cart',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'price': price,
        'quantity': quantity,
      },
    );
  }

  static Future<void> logPurchase({
    required String orderId,
    required double value,
    required String currency,
  }) async {
    await _analytics.logPurchase(
      transactionId: orderId,
      value: value,
      currency: currency,
    );
  }
}
