import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl = "https://fakestoreapi.com/products";

  Future<List<Product>> fetchProducts({String? category}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800)); 
      
      String url = (category == null || category == "Tất cả") 
          ? baseUrl 
          : "$baseUrl/category/$category";
          
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối mạng!");
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/categories"));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<String> categories = ["Tất cả"];
        categories.addAll(body.map((item) => item.toString()).toList());
        return categories;
      }
      return ["Tất cả"];
    } catch (e) {
      return ["Tất cả"];
    }
  }
}
