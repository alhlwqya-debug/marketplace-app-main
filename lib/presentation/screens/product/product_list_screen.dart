import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/product_bloc/product_bloc.dart';
import '../../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String? initialCategory;

  const ProductListScreen({super.key, this.initialCategory});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _selectedCategory;
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'الكل',
    'إلكترونيات',
    'ملابس',
    'أغذية',
    'مستحضرات',
    'أثاث',
    'رياضة',
    'كتب',
    'سيارات',
  ];

  // Sorting options
  String _sortBy = 'الأحدث';
  final List<String> _sortOptions = ['الأحدث', 'الأعلى تقييماً', 'السعر: الأقل', 'السعر: الأعلى'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadProducts();
  }

  void _loadProducts({String? query}) {
    context.read<ProductBloc>().add(LoadProducts(
          category: _selectedCategory == 'الكل' ? null : _selectedCategory,
          searchQuery: query,
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'ابحث عن منتجات...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textLight),
          ),
          onSubmitted: (query) =>
              _loadProducts(query: query.isEmpty ? null : query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _loadProducts(
              query: _searchController.text.isEmpty
                  ? null
                  : _searchController.text,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() => _sortBy = value);
              _loadProducts();
            },
            itemBuilder: (_) => _sortOptions
                .map((opt) => PopupMenuItem(value: opt, child: Text(opt)))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == (_selectedCategory ?? 'الكل');
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontSize: 13,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = cat);
                    _loadProducts();
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Product grid
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadProducts,
                          child: Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('لا توجد منتجات',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: state.products[index]);
                    },
                  );
                }

                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _loadProducts());
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
