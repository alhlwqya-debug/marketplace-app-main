import '../../data/models/store_model.dart';

abstract class StoreRepositoryInterface {
  Future<List<StoreModel>> getStores({String? category, int limit});
  Future<StoreModel> getStoreById(String storeId);
  Future<StoreModel> createStore(StoreModel store);
  Future<void> updateStore(StoreModel store);
  Future<void> followStore(String storeId, String userId);
}
