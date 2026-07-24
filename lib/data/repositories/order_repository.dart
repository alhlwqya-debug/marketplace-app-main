import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> getOrders({String? userId, String? storeId}) async {
    Query query = _firestore.collection('orders').orderBy('createdAt', descending: true);

    if (userId != null) {
      query = query.where('buyerId', isEqualTo: userId);
    }
    if (storeId != null) {
      query = query.where('storeId', isEqualTo: storeId);
    }

    final snapshot = await query.limit(50).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['orderId'] = doc.id;
      return OrderModel.fromJson(data);
    }).toList();
  }

  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) {
      throw Exception('Order not found');
    }
    final data = doc.data()!;
    data['orderId'] = doc.id;
    return OrderModel.fromJson(data);
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    final docRef = _firestore.collection('orders').doc();
    final newOrder = order.copyWith(
      orderId: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(newOrder.toJson());
    return newOrder;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) {
      throw Exception('Order not found');
    }
    final data = doc.data()!;
    return {
      'status': data['status'],
      'trackingNumber': data['trackingNumber'],
      'updatedAt': data['updatedAt'],
    };
  }
}
