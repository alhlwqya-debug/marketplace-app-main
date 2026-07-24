import '../../../data/repositories/order_repository.dart';

class TrackOrderUseCase {
  final OrderRepository repository;

  TrackOrderUseCase(this.repository);

  Future<Map<String, dynamic>> call(String orderId) {
    return repository.trackOrder(orderId);
  }
}
