import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<OrderModel> call(OrderModel order) {
    return repository.createOrder(order);
  }
}
