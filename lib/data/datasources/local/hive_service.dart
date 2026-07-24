import 'package:hive_flutter/hive_flutter.dart';
import '../../models/cart_model.dart';

class HiveService {
  static late Box<dynamic> _settingsBox;
  static late Box<dynamic> _cartBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox('settings');
    _cartBox = await Hive.openBox('cart');
  }

  // Settings
  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  static Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Cart
  static Future<void> saveCart(CartModel cart) async {
    await _cartBox.put('current_cart', cart.toJson());
  }

  static CartModel? getCart() {
    final data = _cartBox.get('current_cart');
    if (data != null) {
      return CartModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static Future<void> clearCart() async {
    await _cartBox.delete('current_cart');
  }
}
