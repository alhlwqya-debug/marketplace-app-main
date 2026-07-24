import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductModel>> call({String? category}) {
    return repository.getProducts(category: category);
  }
}
