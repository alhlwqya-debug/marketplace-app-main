import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String productId;
  final String storeId;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String category;
  final String? subCategory;
  final List<String> tags;
  final int inventory;
  final Map<String, dynamic>? variants;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final DateTime createdAt;

  const ProductModel({
    required this.productId,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.category,
    this.subCategory,
    required this.tags,
    required this.inventory,
    this.variants,
    required this.rating,
    required this.reviewCount,
    required this.isActive,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] as String,
      storeId: json['storeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discountPrice'] != null ? (json['discountPrice'] as num).toDouble() : null,
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      inventory: json['inventory'] as int,
      variants: json['variants'] as Map<String, dynamic>?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isActive: json['isActive'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'storeId': storeId,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'tags': tags,
      'inventory': inventory,
      'variants': variants,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  double get finalPrice => discountPrice ?? price;
  double get discountPercent => discountPrice != null 
      ? ((price - discountPrice!) / price * 100).roundToDouble() 
      : 0;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  bool get isInStock => inventory > 0;

  ProductModel copyWith({
    String? productId,
    String? storeId,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    List<String>? images,
    String? category,
    String? subCategory,
    List<String>? tags,
    int? inventory,
    Map<String, dynamic>? variants,
    double? rating,
    int? reviewCount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      images: images ?? this.images,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      tags: tags ?? this.tags,
      inventory: inventory ?? this.inventory,
      variants: variants ?? this.variants,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [productId, storeId, name, description, price, discountPrice, images, category, subCategory, tags, inventory, variants, rating, reviewCount, isActive, createdAt];
}
