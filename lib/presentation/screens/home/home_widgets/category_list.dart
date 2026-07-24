import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {'icon': Icons.checkroom,     'name': 'ملابس',       'key': 'ملابس'},
    {'icon': Icons.phone_android, 'name': 'إلكترونيات', 'key': 'إلكترونيات'},
    {'icon': Icons.home,          'name': 'بيت',         'key': 'أثاث'},
    {'icon': Icons.restaurant,    'name': 'طعام',        'key': 'أغذية'},
    {'icon': Icons.directions_car,'name': 'سيارات',      'key': 'سيارات'},
    {'icon': Icons.spa,           'name': 'جمال',        'key': 'مستحضرات'},
    {'icon': Icons.sports,        'name': 'رياضة',       'key': 'رياضة'},
    {'icon': Icons.menu_book,     'name': 'كتب',         'key': 'كتب'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () => context.push(
              '${AppRoutes.productList}?category=${category['key']}',
            ),
            child: Column(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
