import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  final String storeId;
  final String ownerId;
  final String name;
  final String? logoUrl;
  final String description;
  final String category;
  final GeoPoint? location;
  final double rating;
  final int followersCount;
  final StoreStatus status;
  final DateTime createdAt;

  const StoreModel({
    required this.storeId,
    required this.ownerId,
    required this.name,
    this.logoUrl,
    required this.description,
    required this.category,
    this.location,
    required this.rating,
    required this.followersCount,
    required this.status,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeId: json['storeId'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      description: json['description'] as String,
      category: json['category'] as String,
      location: json['location'] as GeoPoint?,
      rating: (json['rating'] as num).toDouble(),
      followersCount: json['followersCount'] as int,
      status: StoreStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StoreStatus.pending,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'ownerId': ownerId,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'category': category,
      'location': location,
      'rating': rating,
      'followersCount': followersCount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  StoreModel copyWith({
    String? storeId,
    String? ownerId,
    String? name,
    String? logoUrl,
    String? description,
    String? category,
    GeoPoint? location,
    double? rating,
    int? followersCount,
    StoreStatus? status,
    DateTime? createdAt,
  }) {
    return StoreModel(
      storeId: storeId ?? this.storeId,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      followersCount: followersCount ?? this.followersCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [storeId, ownerId, name, logoUrl, description, category, location, rating, followersCount, status, createdAt];
}

enum StoreStatus { active, pending, suspended }
