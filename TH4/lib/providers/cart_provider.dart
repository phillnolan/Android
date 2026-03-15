import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<dynamic> _items = [];
  List<dynamic> get items => _items;

  int get itemCount => _items.length;

  // Placeholder for future logic
  void addToCart(dynamic product) {
    _items.add(product);
    notifyListeners();
  }
}
