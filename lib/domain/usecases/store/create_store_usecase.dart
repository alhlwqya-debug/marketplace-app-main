import '../../../data/models/store_model.dart';
import '../../../data/repositories/store_repository.dart';

class CreateStoreUseCase {
  final StoreRepository repository;

  CreateStoreUseCase(this.repository);

  Future<StoreModel> call(StoreModel store) {
    return repository.createStore(store);
  }
}
