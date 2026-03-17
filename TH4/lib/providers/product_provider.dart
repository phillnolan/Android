import 'package:flutter/material.dart';
import 'package:th4/core/api_state.dart';
import 'package:th4/core/constants/app_constants.dart';
import 'package:th4/models/product_model.dart';
import 'package:th4/services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiState<List<ProductModel>> _productsState = const ApiInitial();
  ApiState<List<ProductModel>> get productsState => _productsState;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int _currentLimit = AppConstants.pageSize;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchQuery = '';
  String _selectedCategory = '';
  bool _isGridView = true;

  String get selectedCategory => _selectedCategory;
  bool get isGridView => _isGridView;

  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  /// Trả về danh sách sản phẩm sau khi đã áp dụng lọc theo danh mục và tìm kiếm
  List<ProductModel> get filteredProducts {
    final state = _productsState;
    if (state is ApiSuccess<List<ProductModel>>) {
      return state.data.where((p) {
        final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory.isEmpty || p.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    }
    return [];
  }

  /// Cập nhật từ khóa tìm kiếm và thông báo cho UI
  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Lọc sản phẩm theo danh mục. Nếu chọn lại danh mục cũ sẽ bỏ lọc.
  void filterByCategory(String category) {
    if (_selectedCategory == category) {
      _selectedCategory = ''; // Toggle off
    } else {
      _selectedCategory = category;
    }
    notifyListeners();
  }

  /// Tải danh sách sản phẩm từ API. Hỗ trợ làm mới (refresh) dữ liệu.
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentLimit = AppConstants.pageSize;
      _hasMore = true;
    }

    // Chỉ hiển thị loading toàn màn hình nếu chưa có dữ liệu hoặc là init load
    if (_productsState is! ApiSuccess || (isRefresh && _productsState is! ApiSuccess)) {
      _productsState = const ApiLoading();
      notifyListeners();
    }

    try {
      final result = await _apiService.getProducts(limit: _currentLimit);

      if (result is ApiSuccess<List<ProductModel>>) {
        _productsState = result;
        if (result.data.length < _currentLimit) {
          _hasMore = false;
        }
      } else {
        _productsState = result;
      }
    } catch (e) {
      _productsState = ApiError(e.toString());
    }
    notifyListeners();
  }

  /// Tải thêm sản phẩm (Infinite Scroll) bằng cách tăng giới hạn limit
  Future<void> fetchMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextLimit = _currentLimit + AppConstants.pageSize;
      final result = await _apiService.getProducts(limit: nextLimit);

      if (result is ApiSuccess<List<ProductModel>>) {
        final newData = result.data;
        final currentData = (_productsState as ApiSuccess<List<ProductModel>>).data;

        // Cập nhật limit hiện tại
        _currentLimit = nextLimit;

        // Nếu số lượng tải về không tăng thêm, nghĩa là hết dữ liệu
        if (newData.length <= currentData.length) {
          _hasMore = false;
        }

        _productsState = ApiSuccess(newData);
      }
    } catch (e) {
      debugPrint('Error loading more: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
