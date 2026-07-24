import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary Palette ────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFFFF6B00); // برتقالي سوق
  static const Color primaryLight   = Color(0xFFFF8F3E);
  static const Color primaryDark    = Color(0xFFCC5500);
  static const Color primarySurface = Color(0xFFFFF3EB);

  // ─── Secondary Palette ──────────────────────────────────────────────────────
  static const Color secondary        = Color(0xFF00897B); // فيروزي
  static const Color secondaryLight   = Color(0xFF4EBAAA);
  static const Color secondaryDark    = Color(0xFF005B4F);
  static const Color secondarySurface = Color(0xFFE0F2F1);

  // ─── Accent ─────────────────────────────────────────────────────────────────
  static const Color accent      = Color(0xFFFFC107); // عنبري للتمييز
  static const Color accentDark  = Color(0xFFFF8F00);
  static const Color accentLight = Color(0xFFFFECB3);

  // ─── Neutral / Grey Scale ───────────────────────────────────────────────────
  static const Color grey50  = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ─── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF4A4A68);
  static const Color textHint      = Color(0xFF9E9EBD);
  static const Color textDisabled  = Color(0xFFBDBDCE);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Background / Surface ───────────────────────────────────────────────────
  static const Color background      = Color(0xFFF8F9FA);
  static const Color backgroundDark  = Color(0xFF121212);
  static const Color surface         = Color(0xFFFFFFFF);
  static const Color surfaceDark     = Color(0xFF1E1E2E);
  static const Color cardBackground  = Color(0xFFFFFFFF);
  static const Color scaffoldBg      = Color(0xFFF4F6F8);

  // ─── Status Colors ───────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF2E7D32);
  static const Color successLight   = Color(0xFFE8F5E9);
  static const Color successSurface = Color(0xFFC8E6C9);

  static const Color error        = Color(0xFFC62828);
  static const Color errorLight   = Color(0xFFFFEBEE);
  static const Color errorSurface = Color(0xFFFFCDD2);

  static const Color warning        = Color(0xFFE65100);
  static const Color warningLight   = Color(0xFFFFF8E1);
  static const Color warningSurface = Color(0xFFFFE0B2);

  static const Color info        = Color(0xFF01579B);
  static const Color infoLight   = Color(0xFFE3F2FD);
  static const Color infoSurface = Color(0xFFBBDEFB);

  // ─── Order Status ────────────────────────────────────────────────────────────
  static const Color statusPending   = Color(0xFFFF8F00); // انتظار
  static const Color statusConfirmed = Color(0xFF1565C0); // مؤكد
  static const Color statusShipped   = Color(0xFF6A1B9A); // شُحن
  static const Color statusDelivered = Color(0xFF2E7D32); // تسلّم
  static const Color statusCancelled = Color(0xFFC62828); // ملغي

  // ─── Payment Status ──────────────────────────────────────────────────────────
  static const Color paymentPaid    = Color(0xFF2E7D32);
  static const Color paymentPending = Color(0xFFFF8F00);
  static const Color paymentFailed  = Color(0xFFC62828);
  static const Color paymentRefund  = Color(0xFF01579B);

  // ─── Rating ──────────────────────────────────────────────────────────────────
  static const Color ratingActive   = Color(0xFFFFB300);
  static const Color ratingInactive = Color(0xFFE0E0E0);

  // ─── Border ──────────────────────────────────────────────────────────────────
  static const Color border        = Color(0xFFE8EAED);
  static const Color borderFocused = Color(0xFFFF6B00);
  static const Color divider       = Color(0xFFEEEEEE);

  // ─── Shadow ──────────────────────────────────────────────────────────────────
  static const Color shadow        = Color(0x1A000000);
  static const Color shadowMedium  = Color(0x33000000);

  // ─── Bottom Navigation ───────────────────────────────────────────────────────
  static const Color navActive     = Color(0xFFFF6B00);
  static const Color navInactive   = Color(0xFF9E9E9E);
  static const Color navBackground = Color(0xFFFFFFFF);

  // ─── Gradient Presets ────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFFFF8F3E), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Transparent ─────────────────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;

  // ─── Dark Theme Overrides ────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D0D1A);
  static const Color darkSurface    = Color(0xFF1A1A2E);
  static const Color darkCard       = Color(0xFF242436);
  static const Color darkBorder     = Color(0xFF2E2E44);
  static const Color darkTextPrimary = Color(0xFFF0F0FF);
  static const Color darkTextSecondary = Color(0xFFB0B0CC);

  // ─── Utility Methods ─────────────────────────────────────────────────────────
  /// Returns status color for an order status string
  static Color orderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':   return statusPending;
      case 'confirmed': return statusConfirmed;
      case 'shipped':   return statusShipped;
      case 'delivered': return statusDelivered;
      case 'cancelled': return statusCancelled;
      default:          return grey500;
    }
  }

  /// Returns status color for a payment status string
  static Color paymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':     return paymentPaid;
      case 'pending':  return paymentPending;
      case 'failed':   return paymentFailed;
      case 'refunded': return paymentRefund;
      default:         return grey500;
    }
  }
}
