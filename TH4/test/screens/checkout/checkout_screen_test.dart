import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:th4/providers/cart_provider.dart';
import 'package:th4/screens/checkout/checkout_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('CheckoutScreen displays order summary and user info form', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(
          home: CheckoutScreen(),
        ),
      ),
    );

    // Verify presence of Form fields
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Họ tên'), findsOneWidget);
    expect(find.text('Số điện thoại'), findsOneWidget);
    expect(find.text('Địa chỉ'), findsOneWidget);

    // Verify presence of confirmation button
    expect(find.text('XÁC NHẬN ĐẶT HÀNG'), findsOneWidget);
  });

  testWidgets('CheckoutScreen shows validation errors for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(
          home: CheckoutScreen(),
        ),
      ),
    );

    // Tap the submit button without filling the form
    await tester.tap(find.text('XÁC NHẬN ĐẶT HÀNG'));
    await tester.pumpAndSettle();

    // Verify validation error messages
    expect(find.text('Vui lòng nhập họ tên'), findsOneWidget);
    expect(find.text('Vui lòng nhập số điện thoại'), findsOneWidget);
    expect(find.text('Vui lòng nhập địa chỉ'), findsOneWidget);
  });

  testWidgets('CheckoutScreen submits order successfully and shows dialog', (WidgetTester tester) async {
    final cartProvider = CartProvider();
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cartProvider),
        ],
        child: MaterialApp(
          initialRoute: '/checkout',
          routes: {
            '/checkout': (context) => const CheckoutScreen(),
            '/': (context) => const Scaffold(body: Text('Home Screen')),
          },
        ),
      ),
    );

    // Enter valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '0123456789');
    await tester.enterText(find.byType(TextFormField).at(2), '123 Test St');

    // Tap the submit button
    await tester.tap(find.text('XÁC NHẬN ĐẶT HÀNG'));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Đặt hàng thành công!'), findsOneWidget);
    expect(find.text('Cảm ơn bạn đã mua sắm tại TH4.'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();

    // Verify cart is cleared (totalQuantity should be 0)
    expect(cartProvider.totalQuantity, 0);
  });
}
