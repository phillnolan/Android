import 'package:flutter/material.dart';
import 'package:th4/screens/home/home_screen.dart';
import 'package:th4/screens/cart/cart_screen.dart';
import 'package:th4/screens/product_detail/product_detail_screen.dart';
import 'package:th4/screens/orders/orders_screen.dart';
import 'package:th4/models/product_model.dart';

import 'package:th4/screens/checkout/checkout_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String checkout = '/checkout';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    detail: (context) {
      final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
      return ProductDetailScreen(product: product);
    },
    cart: (context) => const CartScreen(),
    orders: (context) => const OrdersScreen(),
    checkout: (context) => const CheckoutScreen(),
  };
}
