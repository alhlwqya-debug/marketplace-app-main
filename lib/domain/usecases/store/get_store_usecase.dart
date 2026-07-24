import '../../../data/models/store_model.dart';
import '../../../data/repositories/store_repository.dart';

class GetStoreUseCase {
  final StoreRepository repository;

  GetStoreUseCase(this.repository);

  Future<StoreModel> call(String storeId) {
    return repository.getStoreById(storeId);
  }
}
