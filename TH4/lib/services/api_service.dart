import 'package:dio/dio.dart';
import 'package:th4/core/api_state.dart';
import 'package:th4/core/constants/app_constants.dart';
import 'package:th4/models/product_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<ApiState<List<ProductModel>>> getProducts({int? limit}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: limit != null ? {'limit': limit} : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final products = data.map((json) => ProductModel.fromJson(json)).toList();
        return ApiSuccess(products);
      } else {
        return ApiError('Lỗi server: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Lỗi kết nối mạng');
    } catch (e) {
      return ApiError('Lỗi không xác định: $e');
    }
  }
}
