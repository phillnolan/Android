import 'package:flutter/material.dart';
import 'package:th4/screens/home/home_screen.dart';
import 'package:th4/screens/cart/cart_screen.dart';
import 'package:th4/screens/product_detail/product_detail_screen.dart';
import 'package:th4/screens/orders/orders_screen.dart';
import 'package:th4/models/product_model.dart';
import 'package:th4/screens/checkout/checkout_screen.dart';
import 'package:th4/screens/chat/chat_screen.dart';
import 'package:th4/screens/auth/login_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String detail = '/detail';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String checkout = '/checkout';
  static const String chat = '/chat';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    detail: (context) {
      final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
      return ProductDetailScreen(product: product);
    },
    cart: (context) => const CartScreen(),
    orders: (context) => const OrdersScreen(),
    checkout: (context) => const CheckoutScreen(),
    chat: (context) => const ChatScreen(),
  };
}
