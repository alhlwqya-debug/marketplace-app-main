import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static User? get currentUser => auth.currentUser;
  static String? get currentUserId => auth.currentUser?.uid;
  static bool get isAuthenticated => auth.currentUser != null;

  // Collections references
  static CollectionReference get usersCollection => firestore.collection('users');
  static CollectionReference get storesCollection => firestore.collection('stores');
  static CollectionReference get productsCollection => firestore.collection('products');
  static CollectionReference get ordersCollection => firestore.collection('orders');
  static CollectionReference get reviewsCollection => firestore.collection('reviews');
  static CollectionReference get cartsCollection => firestore.collection('carts');
  static CollectionReference get notificationsCollection => firestore.collection('notifications');

  // Storage references
  static Reference get userImagesRef => storage.ref().child('users');
  static Reference get storeImagesRef => storage.ref().child('stores');
  static Reference get productImagesRef => storage.ref().child('products');
  static Reference get reviewImagesRef => storage.ref().child('reviews');
}
