import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../../services/supabase_service.dart';

class SupabaseProductRepository {
  final SupabaseClient _client = SupabaseService.client;
  final _table = 'products';

  /// Get products with pagination
  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client
        .from(_table)
        .select('*')
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    if (category != null) {
      query = query.eq('category', category);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final response = await query;
    return (response as List)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get featured products (top rated)
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    final response = await _client
        .from(_table)
        .select('*')
        .eq('is_active', true)
        .order('rating', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get product by ID
  Future<ProductModel> getProductById(String productId) async {
    final response = await _client
        .from(_table)
        .select('*')
        .eq('product_id', productId)
        .single();

    if (response == null) {
      throw Exception('Product not found');
    }

    return ProductModel.fromJson(response as Map<String, dynamic>);
  }

  /// Search products by name or tags
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _client
        .from(_table)
        .select('*')
        .eq('is_active', true)
        .or('name.ilike.%$query%, description.ilike.%$query%, tags.cs.{$query}')
        .order('rating', ascending: false)
        .limit(20);

    return (response as List)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Create product with image upload
  Future<ProductModel> createProduct(ProductModel product, List<dynamic> images) async {
    // Upload images to Supabase Storage
    final imageUrls = <String>[];

    for (final image in images) {
      if (image is String && image.startsWith('http')) {
        // Already a URL
        imageUrls.add(image);
      } else {
        // Upload new image
        // Implementation depends on image type (File, Uint8List, etc.)
      }
    }

    final data = {
      ...product.toJson(),
      'images': imageUrls,
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await _client
        .from(_table)
        .insert(data)
        .select()
        .single();

    return ProductModel.fromJson(response as Map<String, dynamic>);
  }

  /// Update product
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _client
        .from(_table)
        .update(product.toJson())
        .eq('product_id', product.productId)
        .select()
        .single();

    return ProductModel.fromJson(response as Map<String, dynamic>);
  }

  /// Delete product (soft delete)
  Future<void> deleteProduct(String productId) async {
    await _client
        .from(_table)
        .update({'is_active': false})
        .eq('product_id', productId);
  }

  /// Real-time product updates
  Stream<List<ProductModel>> subscribeToProducts() {
    return _client
        .from(_table)
        .stream(primaryKey: ['product_id'])
        .eq('is_active', true)
        .map((data) => data
            .map((json) => ProductModel.fromJson(json))
            .toList());
  }

  /// Get products by store
  Future<List<ProductModel>> getProductsByStore(String storeId) async {
    final response = await _client
        .from(_table)
        .select('*')
        .eq('store_id', storeId)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Update product inventory
  Future<void> updateInventory(String productId, int quantity) async {
    await _client
        .from(_table)
        .update({'inventory': quantity})
        .eq('product_id', productId);
  }

  /// Decrement inventory (for orders)
  Future<void> decrementInventory(String productId, int amount) async {
    await _client.rpc('decrement_inventory', params: {
      'product_id': productId,
      'amount': amount,
    });
  }
}
