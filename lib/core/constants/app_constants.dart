class AppConstants {
  // API
  static const String baseUrl = 'https://api.marketplace.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_data';
  static const String onboardingKey = 'onboarding_seen';

  // Pagination
  static const int pageSize = 20;

  // Image
  static const String placeholderImage = 'assets/images/placeholders/product.png';
  static const String avatarPlaceholder = 'assets/images/placeholders/avatar.png';

  // Currency
  static const String currency = 'ر.س';
  static const String currencyCode = 'SAR';

  // Limits
  static const int maxProductImages = 5;
  static const int maxReviewImages = 3;
  static const int maxCartItems = 50;
}
