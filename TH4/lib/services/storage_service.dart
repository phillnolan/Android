import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:th4/models/cart_item_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _cartKey = 'shopping_cart';

  // Lưu danh sách giỏ hàng
  Future<void> saveCart(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_cartKey, encodedData);
  }

  // Tải danh sách giỏ hàng
  Future<List<CartItemModel>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_cartKey);

    if (encodedData == null || encodedData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Xóa giỏ hàng
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
