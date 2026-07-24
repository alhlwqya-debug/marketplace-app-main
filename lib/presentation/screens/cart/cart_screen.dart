import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/cart_model.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int itemCount = 0;
            if (state is CartLoaded) {
              itemCount = state.cart.itemCount;
            }
            return Text('${AppStrings.cart} (${itemCount})');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('إفراغ السلة'),
                  content: const Text('هل أنت متأكد من إفراغ السلة؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CartBloc>().add(ClearCart());
                        Navigator.pop(context);
                      },
                      child: const Text('تأكيد', style: TextStyle(color: AppTheme.errorColor)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cart.isEmpty) {
              return _buildEmptyCart(context);
            }
            return _buildCartContent(context, state.cart);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && !state.cart.isEmpty) {
            return _buildCheckoutBar(context, state.cart);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.emptyCart,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'تصفح المنتجات',
            onPressed: () => context.go(AppRoutes.home),
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartModel cart) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Cart Items
        ...cart.items.map((item) => _buildCartItem(context, item)),
        const SizedBox(height: 24),
        // Order Summary
        _buildOrderSummary(context, cart),
        const SizedBox(height: 16),
        // Shipping Address
        _buildShippingAddress(context),
        const SizedBox(height: 16),
        // Payment Methods
        _buildPaymentMethods(context),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Dismissible(
      key: Key(item.cartItemId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: AppTheme.errorColor),
      ),
      onDismissed: (_) {
        context.read<CartBloc>().add(RemoveFromCart(item.cartItemId));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: AppTheme.backgroundColor,
                child: item.productImage != null
                    ? Image.network(item.productImage!, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported, color: AppTheme.textLight),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(0)} ر.س',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity Controls
                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onPressed: item.quantity > 1
                            ? () => context.read<CartBloc>().add(
                                  UpdateQuantity(item.cartItemId, item.quantity - 1))
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.quantity.toString(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _quantityButton(
                        icon: Icons.add,
                        onPressed: () => context.read<CartBloc>().add(
                            UpdateQuantity(item.cartItemId, item.quantity + 1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
              onPressed: () => context.read<CartBloc>().add(RemoveFromCart(item.cartItemId)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({required IconData icon, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartModel cart) {
    final discount = 20.0; // Example discount
    final shipping = 15.0;
    final total = cart.subtotal - discount + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الطلب:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _summaryRow(AppStrings.subtotal, '${cart.subtotal.toStringAsFixed(0)} ر.س'),
          _summaryRow(AppStrings.discount, '-${discount.toStringAsFixed(0)} ر.س', isDiscount: true),
          _summaryRow(AppStrings.shipping, '${shipping.toStringAsFixed(0)} ر.س'),
          const Divider(height: 24),
          _summaryRow(
            AppStrings.total,
            '${total.toStringAsFixed(0)} ر.س',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? AppTheme.successColor
                  : isTotal
                      ? AppTheme.primaryColor
                      : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'عنوان الشحن:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('تغيير'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الرياض، حي العليا',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'شارع الملك فهد، عمارة 12، شقة 45',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    final methods = [
      {'icon': Icons.credit_card, 'name': 'بطاقة ائتمان'},
      {'icon': Icons.apple, 'name': 'Apple Pay'},
      {'icon': Icons.payment, 'name': 'Google Pay'},
      {'icon': Icons.money, 'name': 'الدفع عند الاستلام'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'طريقة الدفع:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: methods.map((method) {
              return ChoiceChip(
                avatar: Icon(method['icon'] as IconData, size: 18),
                label: Text(method['name'] as String),
                selected: false,
                onSelected: (_) {},
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartModel cart) {
    final discount = 20.0;
    final shipping = 15.0;
    final total = cart.subtotal - discount + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإجمالي:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${total.toStringAsFixed(0)} ر.س',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomButton(
                text: 'تأكيد الطلب',
                onPressed: () => context.push(AppRoutes.checkout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
