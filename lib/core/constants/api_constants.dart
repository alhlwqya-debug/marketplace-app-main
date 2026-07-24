class ApiConstants {
  static const String baseUrl    = 'https://api.marketplace.com';
  static const String apiVersion = 'v1';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String register      = '/auth/register';
  static const String login         = '/auth/login';
  static const String logout        = '/auth/logout';
  static const String refresh       = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyPhone   = '/auth/verify-phone';
  static const String socialAuth    = '/auth/social';

  // ─── Stores ───────────────────────────────────────────────────────────────
  static const String stores        = '/stores';
  static const String storeProducts = '/stores/{id}/products';
  static const String storeReviews  = '/stores/{id}/reviews';
  static const String followStore   = '/stores/{id}/follow';
  static const String nearbyStores  = '/stores/nearby';

  // ─── Products ─────────────────────────────────────────────────────────────
  static const String products         = '/products';
  static const String searchProducts   = '/products/search';
  static const String featuredProducts = '/products/featured';
  static const String productReview    = '/products/{id}/review';

  // ─── Cart & Orders ────────────────────────────────────────────────────────
  static const String cart          = '/cart';
  static const String cartItems     = '/cart/items';
  static const String orders        = '/orders';
  static const String orderStatus   = '/orders/{id}/status';
  static const String orderTracking = '/orders/{id}/tracking';

  // ─── Payments ─────────────────────────────────────────────────────────────
  static const String createPaymentIntent = '/payments/create-intent';
  static const String refundPayment       = '/payments/refund';
  static const String paymentMethods      = '/payments/methods';

  // ─── User Profile ─────────────────────────────────────────────────────────
  static const String profile       = '/profile';
  static const String updateProfile = '/profile/update';
  static const String uploadAvatar  = '/profile/avatar';
  static const String addresses     = '/profile/addresses';

  // ─── Notifications ────────────────────────────────────────────────────────
  static const String notifications        = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String updateFcmToken       = '/notifications/fcm-token';

  // ─── Analytics ────────────────────────────────────────────────────────────
  static const String trackEvent = '/analytics/events';

  // ─── Helpers ──────────────────────────────────────────────────────────────
  /// Builds a versioned API path: /api/v1/...
  static String path(String endpoint) =>
      '/api/$apiVersion$endpoint';

  /// Replaces path parameter placeholder: '/stores/{id}/...' -> '/stores/abc/...'
  static String withId(String template, String id) =>
      template.replaceFirst('{id}', id);
}
