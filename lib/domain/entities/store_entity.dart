class StoreEntity {
  final String storeId;
  final String ownerId;
  final String name;
  final String? logoUrl;
  final String description;
  final String category;
  final double rating;
  final int followersCount;
  final String status;

  const StoreEntity({
    required this.storeId,
    required this.ownerId,
    required this.name,
    this.logoUrl,
    required this.description,
    required this.category,
    required this.rating,
    required this.followersCount,
    required this.status,
  });
}
