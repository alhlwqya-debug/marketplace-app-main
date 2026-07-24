import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('تتبع الطلب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTrackingStep(
              icon: Icons.check_circle,
              title: 'تم تأكيد الطلب',
              subtitle: '20 يوليو 2026 - 10:30 ص',
              isActive: true,
              isCompleted: true,
            ),
            _buildTrackingLine(),
            _buildTrackingStep(
              icon: Icons.local_shipping,
              title: 'تم الشحن',
              subtitle: '21 يوليو 2026 - 02:15 م',
              isActive: true,
              isCompleted: true,
            ),
            _buildTrackingLine(),
            _buildTrackingStep(
              icon: Icons.delivery_dining,
              title: 'قيد التوصيل',
              subtitle: '22 يوليو 2026 - 09:00 ص',
              isActive: true,
              isCompleted: false,
            ),
            _buildTrackingLine(),
            _buildTrackingStep(
              icon: Icons.home,
              title: 'تم التوصيل',
              subtitle: 'متوقع: 22 يوليو 2026',
              isActive: false,
              isCompleted: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.successColor
                : isActive
                    ? AppTheme.primaryColor
                    : AppTheme.dividerColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive || isCompleted ? Colors.white : AppTheme.textLight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive || isCompleted ? AppTheme.textPrimary : AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isActive || isCompleted ? AppTheme.textSecondary : AppTheme.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingLine() {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Container(
        width: 2,
        height: 40,
        color: AppTheme.primaryColor.withOpacity(0.3),
      ),
    );
  }
}
