import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:th4/providers/product_provider.dart';
import 'package:th4/providers/cart_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App provider integration test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Build a widget with Providers to verify integration
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('TH4 Provider Test')),
          ),
        ),
      ),
    );

    // Verify text
    expect(find.text('TH4 Provider Test'), findsOneWidget);
    
    // Verify Providers are accessible
    final BuildContext context = tester.element(find.text('TH4 Provider Test'));
    expect(Provider.of<ProductProvider>(context, listen: false), isNotNull);
    expect(Provider.of<CartProvider>(context, listen: false), isNotNull);
  });
}
