import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? discountPrice;
  final int quantity;
  final String storeId;
  final String storeName;
  final Map<String, String>? selectedVariants; // e.g. {color: red, size: L}

  const CartItemEntity({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.discountPrice,
    required this.quantity,
    required this.storeId,
    required this.storeName,
    this.selectedVariants,
  });

  double get effectivePrice => discountPrice ?? price;
  double get subtotal => effectivePrice * quantity;

  CartItemEntity copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? discountPrice,
    int? quantity,
    String? storeId,
    String? storeName,
    Map<String, String>? selectedVariants,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      selectedVariants: selectedVariants ?? this.selectedVariants,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        price,
        discountPrice,
        quantity,
        storeId,
        storeName,
        selectedVariants,
      ];
}

class CartEntity extends Equatable {
  final String userId;
  final List<CartItemEntity> items;
  final DateTime? updatedAt;

  const CartEntity({
    required this.userId,
    required this.items,
    this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get discount =>
      items.fold(
        0.0,
        (sum, item) => sum +
            ((item.discountPrice != null)
                ? (item.price - item.discountPrice!) * item.quantity
                : 0.0),
      );

  bool get isEmpty => items.isEmpty;

  /// Groups items by storeId for multi-store checkout
  Map<String, List<CartItemEntity>> get itemsByStore {
    final Map<String, List<CartItemEntity>> map = {};
    for (final item in items) {
      map.putIfAbsent(item.storeId, () => []).add(item);
    }
    return map;
  }

  CartEntity copyWith({
    String? userId,
    List<CartItemEntity>? items,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [userId, items, updatedAt];
}
