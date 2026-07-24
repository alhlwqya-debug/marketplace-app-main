import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser!.uid;

  // ─── Read ─────────────────────────────────────────────────────────────────
  Future<List<StoreModel>> getStores({
    String? category,
    String? searchQuery,
    int limit = 20,
  }) async {
    Query query = _firestore
        .collection('stores')
        .where('status', isEqualTo: 'active')
        .orderBy('rating', descending: true)
        .limit(limit);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    final stores = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['storeId'] = doc.id;
      return StoreModel.fromJson(data);
    }).toList();

    // Client-side search filter (Firestore doesn't support full-text search)
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      return stores
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              (s.description?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return stores;
  }

  Future<StoreModel> getStoreById(String storeId) async {
    final doc = await _firestore.collection('stores').doc(storeId).get();
    if (!doc.exists) throw Exception('المتجر غير موجود');
    final data = doc.data()!;
    data['storeId'] = doc.id;
    return StoreModel.fromJson(data);
  }

  Future<StoreModel> getStoreByOwnerId(String ownerId) async {
    final snapshot = await _firestore
        .collection('stores')
        .where('ownerId', isEqualTo: ownerId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) throw Exception('لا يوجد متجر لهذا المستخدم');
    final data = snapshot.docs.first.data();
    data['storeId'] = snapshot.docs.first.id;
    return StoreModel.fromJson(data);
  }

  Future<List<StoreModel>> getNearbyStores({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    // Fetch active stores and filter client-side (GeoFirestore not in scope)
    final snapshot = await _firestore
        .collection('stores')
        .where('status', isEqualTo: 'active')
        .limit(100)
        .get();

    final deltaLng = radiusKm / (111.0 * _cosApprox(latitude));
    final deltaLat = radiusKm / 111.0;

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['storeId'] = doc.id;
      return StoreModel.fromJson(data);
    }).where((store) {
      final loc = store.location;
      if (loc == null) return false;
      return loc.latitude >= latitude - deltaLat &&
          loc.latitude <= latitude + deltaLat &&
          loc.longitude >= longitude - deltaLng &&
          loc.longitude <= longitude + deltaLng;
    }).toList();
  }

  // ─── Write ────────────────────────────────────────────────────────────────
  Future<StoreModel> createStore(StoreModel store) async {
    final docRef = _firestore.collection('stores').doc();
    final newStore = store.copyWith(storeId: docRef.id);
    await docRef.set(newStore.toJson());
    return newStore;
  }

  Future<void> updateStore(StoreModel store) async {
    await _firestore
        .collection('stores')
        .doc(store.storeId)
        .update(store.toJson());
  }

  Future<void> deleteStore(String storeId) async {
    await _firestore.collection('stores').doc(storeId).delete();
  }

  // ─── Follow / Unfollow ────────────────────────────────────────────────────
  Future<void> followStore(String storeId) async {
    final userId = _currentUserId;
    final batch = _firestore.batch();

    // Increment followers counter
    batch.update(
      _firestore.collection('stores').doc(storeId),
      {'followersCount': FieldValue.increment(1)},
    );

    // Record in user's following sub-collection
    batch.set(
      _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .doc(storeId),
      {
        'storeId': storeId,
        'followedAt': FieldValue.serverTimestamp(),
      },
    );

    // Record in storeFollowers collection for security rules
    batch.set(
      _firestore.collection('storeFollowers').doc('${userId}_$storeId'),
      {
        'userId': userId,
        'storeId': storeId,
        'followedAt': FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  Future<void> unfollowStore(String storeId) async {
    final userId = _currentUserId;
    final batch = _firestore.batch();

    batch.update(
      _firestore.collection('stores').doc(storeId),
      {'followersCount': FieldValue.increment(-1)},
    );

    batch.delete(
      _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .doc(storeId),
    );

    batch.delete(
      _firestore.collection('storeFollowers').doc('${userId}_$storeId'),
    );

    await batch.commit();
  }

  Future<bool> isFollowing(String storeId) async {
    final doc = await _firestore
        .collection('storeFollowers')
        .doc('${_currentUserId}_$storeId')
        .get();
    return doc.exists;
  }

  // ─── Util ─────────────────────────────────────────────────────────────────
  /// Rough cosine approximation for longitude delta calculation
  double _cosApprox(double degrees) {
    final rad = degrees * 3.14159265358979 / 180.0;
    // Simple Taylor series cos(x) ≈ 1 - x²/2 for small angles
    return 1.0 - (rad * rad) / 2.0;
  }
}
