import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4/core/routes.dart';
import 'package:th4/providers/product_provider.dart';
import 'package:th4/providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TH4 Mini E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
