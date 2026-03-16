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

  /// Tải dữ liệu từ local storage khi khởi tạo
  Future<void> _initCart() async {
    final savedItems = await _storageService.loadCart();
    for (var item in savedItems) {
      _items[item.id] = item;
    }
    notifyListeners();
  }

  /// Lưu dữ liệu vào local storage
  Future<void> _saveToStorage() async {
    await _storageService.saveCart(_items.values.toList());
  }

  /// Trả về bản sao danh sách sản phẩm trong giỏ hàng
  Map<String, CartItemModel> get items => {..._items};

  /// Số lượng loại sản phẩm khác nhau trong giỏ
  int get itemCount => _items.length;

  /// Tổng số lượng sản phẩm (ví dụ: 2 áo + 1 quần = 3)
  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Tổng số tiền tính theo USD (chỉ tính những mục được tick chọn)
  double get totalAmount {
    return _items.values.where((item) => item.isChecked).fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        );
  }

  /// Kiểm tra xem tất cả sản phẩm trong giỏ có được chọn hay không
  bool get isAllSelected {
    if (_items.isEmpty) return false;
    return _items.values.every((item) => item.isChecked);
  }

  /// Thêm sản phẩm vào giỏ hàng với thông tin phân loại (size, color)
  void addItem(ProductModel product, String? size, String? color, {int quantity = 1}) {
    // Tạo khóa duy nhất kết hợp: ID_Size_Color
    final String key = '${product.id}_${size ?? ''}_${color ?? ''}';

    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existing) => existing.copyWith(quantity: existing.quantity + quantity),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItemModel(
          id: key,
          product: product,
          quantity: quantity,
          size: size,
          color: color,
        ),
      );
    }
    _saveToStorage();
    notifyListeners();
  }

  /// Xóa sản phẩm hoàn toàn khỏi giỏ hàng theo key
  void removeItem(String key) {
    _items.remove(key);
    _saveToStorage();
    notifyListeners();
  }

  /// Giảm số lượng của một mục sản phẩm (tối thiểu là 1)
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

  /// Cập nhật số lượng trực tiếp cho một mục sản phẩm
  void updateQuantity(String key, int quantity) {
    if (!_items.containsKey(key) || quantity < 1) return;
    _items.update(key, (existing) => existing.copyWith(quantity: quantity));
    _saveToStorage();
    notifyListeners();
  }

  /// Thay đổi trạng thái checkbox (chọn/bỏ chọn) của một mục sản phẩm
  void toggleCheck(String key) {
    if (!_items.containsKey(key)) return;
    _items.update(
      key,
      (existing) => existing.copyWith(isChecked: !existing.isChecked),
    );
    _saveToStorage();
    notifyListeners();
  }

  /// Chọn hoặc bỏ chọn tất cả sản phẩm trong giỏ hàng
  void toggleSelectAll(bool isSelected) {
    _items.forEach((key, item) {
      _items[key] = item.copyWith(isChecked: isSelected);
    });
    _saveToStorage();
    notifyListeners();
  }

  /// Xóa sạch toàn bộ sản phẩm trong giỏ hàng
  void clearCart() {
    _items.clear();
    _saveToStorage();
    notifyListeners();
  }

  /// Xóa các mục đã được tick chọn (thường gọi sau khi thanh toán thành công)
  void clearCheckedItems() {
    _items.removeWhere((key, item) => item.isChecked);
    _saveToStorage();
    notifyListeners();
  }
}
