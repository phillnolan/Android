import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4/core/constants/currency_utils.dart';
import 'package:th4/models/cart_item_model.dart';
import 'package:th4/providers/cart_provider.dart';

import 'package:th4/core/routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              // 1. "Chọn tất cả" Header
              _buildHeader(cart),

              // 2. Danh sách sản phẩm
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final key = cart.items.keys.elementAt(index);
                    final item = cart.items[key]!;
                    return _buildCartItem(context, cart, key, item);
                  },
                ),
              ),

              // 3. Bottom Checkout Bar
              _buildBottomBar(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Giỏ hàng trống rỗng', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tiếp tục mua sắm'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: cart.isAllSelected,
            onChanged: (val) => cart.toggleSelectAll(val ?? false),
          ),
          const Text('Chọn tất cả', style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(
            onPressed: () => cart.clearCart(),
            child: const Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartProvider cart, String key, CartItemModel item) {
    return Dismissible(
      key: Key(key),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await _showConfirmDialog(context);
      },
      onDismissed: (_) => cart.removeItem(key),
      child: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            onChanged: (_) => cart.toggleCheck(key),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.image,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (item.size != null || item.color != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Loại: ${item.size ?? ''} - ${item.color ?? ''}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyUtils.formatUSDtoVND(item.product.price), // Đồng bộ format
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    _buildQuantityPicker(cart, key, item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityPicker(CartProvider cart, String key, CartItemModel item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: item.quantity > 1 ? () => cart.decreaseQuantity(key) : null,
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => cart.addItem(item.product, item.size, item.color),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng cộng:', style: TextStyle(color: Colors.grey)),
                Text(
                  CurrencyUtils.formatUSDtoVND(cart.totalAmount),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: cart.totalAmount > 0 ? () {
                  Navigator.pushNamed(context, AppRoutes.checkout);
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
