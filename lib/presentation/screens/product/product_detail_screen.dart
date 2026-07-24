import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../blocs/product_bloc/product_bloc.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  Map<String, dynamic>? _selectedVariants;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductDetail(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoaded) {
            return _buildProductDetail(state.product);
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProductBloc>()
                        .add(LoadProductDetail(widget.productId)),
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductDetail(ProductModel product) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 350,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                // Image Carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: 350,
                    viewportFraction: 1.0,
                    autoPlay: product.images.length > 1,
                    onPageChanged: (index, _) {
                      setState(() => _currentImageIndex = index);
                    },
                  ),
                  items: product.images.map((image) {
                    return Container(
                      color: AppTheme.backgroundColor,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported, size: 60, color: AppTheme.textLight),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Page Indicators
                if (product.images.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.images.asMap().entries.map((entry) {
                        return Container(
                          width: _currentImageIndex == entry.key ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentImageIndex == entry.key
                                ? AppTheme.primaryColor
                                : Colors.white.withOpacity(0.7),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name & Rating
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor()
                            ? Icons.star
                            : index < product.rating
                                ? Icons.star_half
                                : Icons.star_border,
                        size: 18,
                        color: Colors.amber[700],
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      '(${product.rating})',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${product.reviewCount} تقييم',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Price
                Row(
                  children: [
                    if (product.hasDiscount) ...[
                      Text(
                        '${product.price.toStringAsFixed(0)} ر.س',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'خصم ${product.discountPercent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.finalPrice.toStringAsFixed(0)} ر.س',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Store Card
                _buildStoreCard(product.storeId),
                const SizedBox(height: 20),
                // Description
                Text(
                  AppStrings.description,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                  child: Text(
                    product.description,
                    maxLines: _isDescriptionExpanded ? null : 3,
                    overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                if (product.description.length > 100)
                  TextButton(
                    onPressed: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                    child: Text(_isDescriptionExpanded ? AppStrings.showLess : AppStrings.readMore),
                  ),
                const SizedBox(height: 20),
                // Variants
                if (product.variants != null) ...[
                  _buildVariants(product.variants!),
                  const SizedBox(height: 20),
                ],
                // Reviews Preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.reviews} (${product.reviewCount})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReviewPreview(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCard(String storeId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.store, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'متجر التقنية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'متجر موثوق',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildVariants(Map<String, dynamic> variants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: variants.entries.map((entry) {
        final values = entry.value as List<dynamic>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key == 'color' ? 'اللون:' : entry.key == 'size' ? 'الحجم:' : entry.key,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: values.map<Widget>((value) {
                final isSelected = _selectedVariants?[entry.key] == value;
                return ChoiceChip(
                  label: Text(value.toString()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedVariants ??= {};
                      _selectedVariants![entry.key] = selected ? value : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReviewPreview() {
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
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أحمد',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 5 ? Icons.star : Icons.star_border,
                        size: 14,
                        color: Colors.amber[700],
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"جودة ممتازة، أنصح بها بشدة!"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
