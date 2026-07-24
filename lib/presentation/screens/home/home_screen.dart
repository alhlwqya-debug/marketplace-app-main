import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/product_bloc/product_bloc.dart';
import '../../blocs/store_bloc/store_bloc.dart';
import '../../widgets/product_card.dart';
import '../../widgets/store_card.dart';
import 'home_widgets/search_bar.dart';
import 'home_widgets/category_list.dart';
import 'home_widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadFeaturedProducts());
    context.read<StoreBloc>().add(const LoadStores());
  }

  Future<void> _refresh() async {
    context.read<ProductBloc>().add(LoadFeaturedProducts());
    context.read<StoreBloc>().add(const LoadStores());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Menu icon
            IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
              onPressed: () {},
            ),
            const Spacer(),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const Spacer(),
            // Notifications
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            // Settings
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(AppRoutes.settings),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HomeSearchBar(),
              ),
              const SizedBox(height: 16),

              // Promo Banner
              const PromoBanner(),
              const SizedBox(height: 24),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppStrings.categories,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              const CategoryList(),
              const SizedBox(height: 24),

              // Featured Stores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.featuredStores,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.storeList),
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Stores Row
              BlocBuilder<StoreBloc, StoreState>(
                builder: (context, state) {
                  if (state is StoreLoading) {
                    return const SizedBox(
                      height: 140,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is StoresLoaded && state.stores.isNotEmpty) {
                    return SizedBox(
                      height: 140,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.stores.length.clamp(0, 10),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final store = state.stores[index];
                          return StoreCard(
                            store: store,
                            onTap: () => context
                                .push(AppRoutes.storeDetailPath(store.storeId)),
                          );
                        },
                      ),
                    );
                  }

                  // Fallback placeholder stores
                  return SizedBox(
                    height: 140,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => StoreCard(
                        name: 'متجر ${['أحمد', 'سعيد', 'فهد', 'نور', 'ياسر'][index]}',
                        rating: 4.5 + (index * 0.1),
                        followers: 1200 + (index * 300),
                        onTap: () => context.push(AppRoutes.storeList),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Recommended Products
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.recommendedProducts,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.productList),
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Products Grid
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is ProductsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                      ),
                    );
                  }
                  if (state is ProductError) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 40, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(state.message),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context
                                .read<ProductBloc>()
                                .add(LoadFeaturedProducts()),
                            child: Text(AppStrings.retry),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              break;
            case 1:
              context.push(AppRoutes.productList);
              break;
            case 2:
              context.push(AppRoutes.cart);
              break;
            case 3:
              context.push(AppRoutes.profile);
              break;
          }
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.navInactive,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: AppStrings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: AppStrings.cart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
