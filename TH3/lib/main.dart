import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call API App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF4D4D),
          primary: const Color(0xFFFF4D4D),
          secondary: const Color(0xFF00E5CC),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
