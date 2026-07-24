class ProductEntity {
  final String productId;
  final String storeId;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String category;
  final int inventory;
  final double rating;
  final int reviewCount;
  final bool isActive;

  const ProductEntity({
    required this.productId,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.category,
    required this.inventory,
    required this.rating,
    required this.reviewCount,
    required this.isActive,
  });

  double get finalPrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
}
