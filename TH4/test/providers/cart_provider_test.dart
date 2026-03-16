import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:th4/models/product_model.dart';
import 'package:th4/providers/cart_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('CartProvider Tests', () {
    late CartProvider cartProvider;
    late ProductModel mockProduct;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cartProvider = CartProvider();
      mockProduct = ProductModel(
        id: 1,
        title: 'Test Product',
        price: 10.0,
        description: 'Description',
        category: 'Category',
        image: 'image.png',
        rating: Rating(rate: 4.5, count: 10),
      );
    });

    test('Initial cart should be empty', () {
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.totalAmount, 0.0);
    });

    test('Add item should work correctly', () {
      cartProvider.addItem(mockProduct, 'M', 'Red');

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.values.first.quantity, 1);
      expect(cartProvider.items.values.first.product.id, 1);
    });

    test('Adding same item should increase quantity', () {
      cartProvider.addItem(mockProduct, 'M', 'Red');
      cartProvider.addItem(mockProduct, 'M', 'Red');

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.values.first.quantity, 2);
    });

    test('Total amount should only calculate checked items', () {
      cartProvider.addItem(mockProduct, 'M', 'Red'); // 10.0
      final productId2 = ProductModel(
        id: 2,
        title: 'Product 2',
        price: 20.0,
        description: 'D',
        category: 'C',
        image: 'I',
        rating: Rating(rate: 4, count: 5),
      );
      cartProvider.addItem(productId2, 'L', 'Blue'); // 20.0

      expect(cartProvider.totalAmount, 30.0);

      // Uncheck item 1
      final key = cartProvider.items.keys.first;
      cartProvider.toggleCheck(key);

      expect(cartProvider.totalAmount, 20.0);
    });

    test('Toggle all should work correctly', () {
      cartProvider.addItem(mockProduct, 'M', 'Red');
      expect(cartProvider.isAllSelected, true);

      cartProvider.toggleSelectAll(false);
      expect(cartProvider.items.values.every((item) => !item.isChecked), true);
      expect(cartProvider.isAllSelected, false);
    });
  });
}
