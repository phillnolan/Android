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

      if (result is ApiSuccess) {
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

  Future<void> fetchMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextLimit = _currentLimit + AppConstants.pageSize;
      final result = await _apiService.getProducts(limit: nextLimit);

      if (result is ApiSuccess) {
        final newData = result.data;
        final currentData = (_productsState as ApiSuccess).data;

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
