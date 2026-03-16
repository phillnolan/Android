import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4/core/routes.dart';
import 'package:th4/models/product_model.dart';
import 'package:th4/providers/cart_provider.dart';

class ProductAttributesBottomSheet extends StatefulWidget {
  final ProductModel product;
  final String actionType; // 'add' or 'buy'

  const ProductAttributesBottomSheet({
    super.key,
    required this.product,
    this.actionType = 'add',
  });

  @override
  State<ProductAttributesBottomSheet> createState() => _ProductAttributesBottomSheetState();
}

class _ProductAttributesBottomSheetState extends State<ProductAttributesBottomSheet> {
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Đen', 'color': Colors.black},
    {'name': 'Xanh', 'color': Colors.blue},
    {'name': 'Xám', 'color': Colors.grey},
    {'name': 'Trắng', 'color': Colors.white},
  ];

  void _onConfirm() {
    if (_selectedSize == null || _selectedColor == null) return;

    final cartProvider = context.read<CartProvider>();
    
    // Thực sự thêm vào giỏ hàng qua Provider
    cartProvider.addItem(
      widget.product,
      _selectedSize,
      _selectedColor,
      quantity: _quantity,
    );

    Navigator.pop(context);

    if (widget.actionType == 'buy') {
      Navigator.pushNamed(context, AppRoutes.cart);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Thêm vào giỏ hàng thành công!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'XEM GIỎ',
            textColor: Colors.white,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tóm tắt sản phẩm
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.formattedPrice,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(height: 32),

          // 2. Lựa chọn Size
          const Text(
            'Kích thước',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _sizes.map((size) {
              final isSelected = _selectedSize == size;
              return ChoiceChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedSize = selected ? size : null);
                },
                selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 3. Lựa chọn Màu sắc
          const Text(
            'Màu sắc',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: _colors.map((colorMap) {
              final colorName = colorMap['name'] as String;
              final colorValue = colorMap['color'] as Color;
              final isSelected = _selectedColor == colorName;

              return GestureDetector(
                onTap: () => setState(() => _selectedColor = colorName),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: colorValue,
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: colorValue == Colors.white ? Colors.black : Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      colorName,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 4. Lựa chọn Số lượng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Số lượng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      icon: const Icon(Icons.remove),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _quantity.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 5. Nút xác nhận
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_selectedSize != null && _selectedColor != null) ? _onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                widget.actionType == 'buy' ? 'Mua ngay' : 'Xác nhận',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
