class OrderEntity {
  final String orderId;
  final String buyerId;
  final String storeId;
  final String status;
  final double total;
  final String paymentStatus;
  final DateTime createdAt;

  const OrderEntity({
    required this.orderId,
    required this.buyerId,
    required this.storeId,
    required this.status,
    required this.total,
    required this.paymentStatus,
    required this.createdAt,
  });
}
