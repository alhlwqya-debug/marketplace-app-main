import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final String userId;
  final List<CartItem> items;
  final DateTime updatedAt;

  const CartModel({
    required this.userId,
    required this.items,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  CartModel copyWith({
    String? userId,
    List<CartItem>? items,
    DateTime? updatedAt,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [userId, items, updatedAt];
}

class CartItem extends Equatable {
  final String cartItemId;
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final Map<String, dynamic>? selectedVariants;
  final String storeId;

  const CartItem({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.selectedVariants,
    required this.storeId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      selectedVariants: json['selectedVariants'] as Map<String, dynamic>?,
      storeId: json['storeId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'selectedVariants': selectedVariants,
      'storeId': storeId,
    };
  }

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? cartItemId,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
    Map<String, dynamic>? selectedVariants,
    String? storeId,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      storeId: storeId ?? this.storeId,
    );
  }

  @override
  List<Object?> get props => [cartItemId, productId, productName, productImage, price, quantity, selectedVariants, storeId];
}
