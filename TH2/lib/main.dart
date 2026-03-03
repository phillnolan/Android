import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/note.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize Firebase if google-services.json is provided for Android
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // ignore: avoid_print
    print('Firebase.initializeApp() failed or not configured yet.');
  }
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = Colors.blue;
    final colorScheme = ColorScheme.fromSeed(seedColor: seed);
    final base = ThemeData.from(colorScheme: colorScheme, useMaterial3: true);
    final theme = base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        centerTitle: false,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      cardTheme: base.cardTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );

    return MaterialApp(
      title: 'Smart Note',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}

