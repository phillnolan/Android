import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:th4/l10n/app_localizations.dart';
import 'package:th4/core/routes.dart';
import 'package:th4/providers/product_provider.dart';
import 'package:th4/providers/cart_provider.dart';
import 'package:th4/providers/locale_provider.dart';
import 'package:th4/providers/chat_provider.dart';
import 'package:th4/providers/auth_provider.dart';
import 'package:th4/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("Firebase initialized!");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'TH4 Mini E-commerce',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
          ],
          // Kiểm tra xem đã đăng nhập chưa để quyết định màn hình đầu tiên
          initialRoute: context.watch<AuthProvider>().isAuthenticated 
              ? AppRoutes.home 
              : AppRoutes.login,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
