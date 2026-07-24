import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _firestore.collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['productId'] = doc.id;
      return ProductModel.fromJson(data);
    }).toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final snapshot = await _firestore.collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['productId'] = doc.id;
      return ProductModel.fromJson(data);
    }).toList();
  }

  Future<ProductModel> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (!doc.exists) {
      throw Exception('Product not found');
    }
    final data = doc.data()!;
    data['productId'] = doc.id;
    return ProductModel.fromJson(data);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    // Simple search by name (for production, use Algolia or ElasticSearch)
    final snapshot = await _firestore.collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['productId'] = doc.id;
      return ProductModel.fromJson(data);
    }).toList();
  }

  Future<void> createProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.productId).set(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.productId).update(product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
