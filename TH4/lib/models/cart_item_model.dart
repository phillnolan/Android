import 'package:th4/models/product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final String? size;
  final String? color;
  final bool isChecked;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    this.size,
    this.color,
    this.isChecked = true,
  });

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    String? size,
    String? color,
    bool? isChecked,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      size: json['size'] as String?,
      color: json['color'] as String?,
      isChecked: json['isChecked'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'color': color,
      'isChecked': isChecked,
    };
  }
}
