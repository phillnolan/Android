import 'package:flutter_test/flutter_test.dart';
import 'package:th4/models/cart_item_model.dart';
import 'package:th4/models/product_model.dart';

void main() {
  group('CartItemModel Tests', () {
    final mockProduct = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 10.0,
      description: 'Description',
      category: 'Category',
      image: 'image.png',
      rating: Rating(rate: 4.5, count: 10),
    );

    test('Should create CartItemModel correctly', () {
      final cartItem = CartItemModel(
        id: '1_blue_m',
        product: mockProduct,
        quantity: 2,
        size: 'M',
        color: 'Blue',
      );

      expect(cartItem.id, '1_blue_m');
      expect(cartItem.product.id, 1);
      expect(cartItem.quantity, 2);
      expect(cartItem.size, 'M');
      expect(cartItem.color, 'Blue');
      expect(cartItem.isChecked, true); // default
    });

    test('toJson and fromJson should work correctly', () {
      final cartItem = CartItemModel(
        id: '1_blue_m',
        product: mockProduct,
        quantity: 1,
        size: 'M',
        color: 'Blue',
        isChecked: false,
      );

      final json = cartItem.toJson();
      final fromJson = CartItemModel.fromJson(json);

      expect(fromJson.id, cartItem.id);
      expect(fromJson.product.id, cartItem.product.id);
      expect(fromJson.quantity, cartItem.quantity);
      expect(fromJson.isChecked, false);
    });
  });
}
