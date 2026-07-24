import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String orderId;
  final String buyerId;
  final String storeId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String paymentMethod;
  final PaymentStatus paymentStatus;
  final Map<String, dynamic> shippingAddress;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.orderId,
    required this.buyerId,
    required this.storeId,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.shippingAddress,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as String,
      buyerId: json['buyerId'] as String,
      storeId: json['storeId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      shippingAddress: json['shippingAddress'] as Map<String, dynamic>,
      trackingNumber: json['trackingNumber'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'buyerId': buyerId,
      'storeId': storeId,
      'items': items.map((e) => e.toJson()).toList(),
      'status': status.name,
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus.name,
      'shippingAddress': shippingAddress,
      'trackingNumber': trackingNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  OrderModel copyWith({
    String? orderId,
    String? buyerId,
    String? storeId,
    List<OrderItem>? items,
    OrderStatus? status,
    double? subtotal,
    double? shippingCost,
    double? total,
    String? paymentMethod,
    PaymentStatus? paymentStatus,
    Map<String, dynamic>? shippingAddress,
    String? trackingNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      buyerId: buyerId ?? this.buyerId,
      storeId: storeId ?? this.storeId,
      items: items ?? this.items,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [orderId, buyerId, storeId, items, status, subtotal, shippingCost, total, paymentMethod, paymentStatus, shippingAddress, trackingNumber, createdAt, updatedAt];
}

class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final Map<String, dynamic>? selectedVariants;

  const OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.selectedVariants,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      selectedVariants: json['selectedVariants'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'selectedVariants': selectedVariants,
    };
  }

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [productId, productName, productImage, price, quantity, selectedVariants];
}

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }
enum PaymentStatus { pending, paid, failed, refunded }
