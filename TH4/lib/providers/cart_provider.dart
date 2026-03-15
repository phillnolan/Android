import 'package:flutter/material.dart';
import 'package:th4/models/cart_item_model.dart';
import 'package:th4/models/product_model.dart';
import 'package:th4/services/storage_service.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItemModel> _items = {};
  final StorageService _storageService = StorageService();

  CartProvider() {
    _initCart();
  }

  // Tải dữ liệu từ local storage khi khởi tạo
  Future<void> _initCart() async {
    final savedItems = await _storageService.loadCart();
    for (var item in savedItems) {
      _items[item.id] = item;
    }
    notifyListeners();
  }

  // Lưu dữ liệu vào local storage
  Future<void> _saveToStorage() async {
    await _storageService.saveCart(_items.values.toList());
  }

  Map<String, CartItemModel> get items => {..._items};

  // Số lượng loại sản phẩm khác nhau trong giỏ
  int get itemCount => _items.length;

  // Tổng số lượng sản phẩm (ví dụ: 2 áo + 1 quần = 3)
  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  // Tổng số tiền tính theo USD (chỉ tính những mục được tick chọn)
  double get totalAmount {
    return _items.values.where((item) => item.isChecked).fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        );
  }

  // Kiểm tra xem tất cả có được chọn hay không
  bool get isAllSelected {
    if (_items.isEmpty) return false;
    return _items.values.every((item) => item.isChecked);
  }

  // Thêm sản phẩm vào giỏ hàng
  void addItem(ProductModel product, String? size, String? color) {
    // Tạo khóa duy nhất kết hợp: ID_Size_Color
    final String key = '${product.id}_${size ?? ''}_${color ?? ''}';

    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existing) => existing.copyWith(quantity: existing.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItemModel(
          id: key,
          product: product,
          quantity: 1,
          size: size,
          color: color,
        ),
      );
    }
    _saveToStorage();
    notifyListeners();
  }

  // Xóa sản phẩm hoàn toàn khỏi giỏ
  void removeItem(String key) {
    _items.remove(key);
    _saveToStorage();
    notifyListeners();
  }

  // Giảm số lượng
  void decreaseQuantity(String key) {
    if (!_items.containsKey(key)) return;

    if (_items[key]!.quantity > 1) {
      _items.update(
        key,
        (existing) => existing.copyWith(quantity: existing.quantity - 1),
      );
    }
    _saveToStorage();
    notifyListeners();
  }

  // Cập nhật số lượng trực tiếp
  void updateQuantity(String key, int quantity) {
    if (!_items.containsKey(key) || quantity < 1) return;
    _items.update(key, (existing) => existing.copyWith(quantity: quantity));
    _saveToStorage();
    notifyListeners();
  }

  // Thay đổi trạng thái checkbox của một mục
  void toggleCheck(String key) {
    if (!_items.containsKey(key)) return;
    _items.update(
      key,
      (existing) => existing.copyWith(isChecked: !existing.isChecked),
    );
    _saveToStorage();
    notifyListeners();
  }

  // Chọn hoặc bỏ chọn tất cả
  void toggleSelectAll(bool isSelected) {
    _items.forEach((key, item) {
      _items[key] = item.copyWith(isChecked: isSelected);
    });
    _saveToStorage();
    notifyListeners();
  }

  // Xóa sạch giỏ hàng
  void clear() {
    _items.clear();
    _saveToStorage();
    notifyListeners();
  }
}
