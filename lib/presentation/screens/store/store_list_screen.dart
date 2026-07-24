import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/store_bloc/store_bloc.dart';
import '../../widgets/store_card.dart';

class StoreListScreen extends StatefulWidget {
  final String? initialCategory;

  const StoreListScreen({super.key, this.initialCategory});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
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
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadStores();
  }

  void _loadStores({String? query}) {
    context.read<StoreBloc>().add(LoadStores(
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
            hintText: 'ابحث عن متجر...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textLight),
          ),
          onSubmitted: (query) => _loadStores(query: query.isEmpty ? null : query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _loadStores(
              query: _searchController.text.isEmpty ? null : _searchController.text,
            ),
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
                final isSelected =
                    cat == (_selectedCategory ?? 'الكل');
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
                    _loadStores();
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Store list
          Expanded(
            child: BlocBuilder<StoreBloc, StoreState>(
              builder: (context, state) {
                if (state is StoreLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is StoreError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadStores,
                          child: Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is StoresLoaded) {
                  if (state.stores.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('لا توجد متاجر', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.stores.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final store = state.stores[index];
                      return StoreCard(
                        store: store,
                        onTap: () =>
                            context.push(AppRoutes.storeDetailPath(store.storeId)),
                      );
                    },
                  );
                }

                // Initial state — trigger load
                WidgetsBinding.instance.addPostFrameCallback((_) => _loadStores());
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
