import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/product/product_detail_screen.dart';
import '../../presentation/screens/product/product_list_screen.dart';
import '../../presentation/screens/product/add_product_screen.dart';
import '../../presentation/screens/store/store_detail_screen.dart';
import '../../presentation/screens/store/store_list_screen.dart';
import '../../presentation/screens/store/seller_dashboard_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/cart/checkout_screen.dart';
import '../../presentation/screens/order/order_history_screen.dart';
import '../../presentation/screens/order/order_tracking_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';

class AppRoutes {
  // ─── Route Paths ──────────────────────────────────────────────────────────
  static const String splash          = '/splash';
  static const String login           = '/login';
  static const String register        = '/register';
  static const String forgotPassword  = '/forgot-password';
  static const String home            = '/';
  static const String productDetail   = '/product/:id';
  static const String productList     = '/products';
  static const String addProduct      = '/products/add';
  static const String storeDetail     = '/store/:id';
  static const String storeList       = '/stores';
  static const String sellerDashboard = '/seller-dashboard';
  static const String cart            = '/cart';
  static const String checkout        = '/checkout';
  static const String orders          = '/orders';
  static const String orderTracking   = '/orders/:id/tracking';
  static const String profile         = '/profile';
  static const String editProfile     = '/profile/edit';
  static const String settings        = '/settings';

  // ─── Typed Path Builders ─────────────────────────────────────────────────
  static String productDetailPath(String id) => '/product/$id';
  static String storeDetailPath(String id)   => '/store/$id';
  static String orderTrackingPath(String id) => '/orders/$id/tracking';

  // ─── Router ───────────────────────────────────────────────────────────────
  static final router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: false,
    routes: [
      // Auth
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Home
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Products
      GoRoute(
        path: productList,
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return ProductListScreen(initialCategory: category);
        },
      ),
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: addProduct,
        builder: (context, state) => const AddProductScreen(),
      ),

      // Stores
      GoRoute(
        path: storeList,
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return StoreListScreen(initialCategory: category);
        },
      ),
      GoRoute(
        path: storeDetail,
        builder: (context, state) {
          final storeId = state.pathParameters['id']!;
          return StoreDetailScreen(storeId: storeId);
        },
      ),
      GoRoute(
        path: sellerDashboard,
        builder: (context, state) => const SellerDashboardScreen(),
      ),

      // Cart & Checkout
      GoRoute(
        path: cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),

      // Orders
      GoRoute(
        path: orders,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: orderTracking,
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderTrackingScreen(orderId: orderId);
        },
      ),

      // Profile
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Global error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'الصفحة غير موجودة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error?.message ?? ''),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    ),
  );
}
