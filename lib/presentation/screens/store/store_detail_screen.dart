import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StoreDetailScreen extends StatelessWidget {
  final String storeId;
  const StoreDetailScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('متجر التقنية'),
              background: Container(
                color: AppTheme.primaryColor.withOpacity(0.2),
                child: const Center(
                  child: Icon(Icons.store, size: 80, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'متجر التقنية',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, size: 18, color: Colors.amber[700]),
                                const SizedBox(width: 4),
                                const Text('4.9 (1,234 تقييم)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('متابعة'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'متجر متخصص في بيع الإلكترونيات والأجهزة الذكية بأفضل الأسعار',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'منتجات المتجر',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
