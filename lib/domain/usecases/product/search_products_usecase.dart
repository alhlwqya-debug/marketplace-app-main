import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<ProductModel>> call(String query) {
    return repository.searchProducts(query);
  }
}
