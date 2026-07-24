import '../../data/models/order_model.dart';

abstract class OrderRepositoryInterface {
  Future<List<OrderModel>> getOrders({String? userId, String? storeId});
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<Map<String, dynamic>> trackOrder(String orderId);
}
