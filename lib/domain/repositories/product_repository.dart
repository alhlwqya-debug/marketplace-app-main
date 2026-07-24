import '../../data/models/product_model.dart';

abstract class ProductRepositoryInterface {
  Future<List<ProductModel>> getProducts({String? category, String? searchQuery, int limit});
  Future<List<ProductModel>> getFeaturedProducts();
  Future<ProductModel> getProductById(String productId);
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);
}
