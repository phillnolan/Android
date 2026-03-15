import 'package:flutter/material.dart';
import 'package:th4/core/constants/app_constants.dart';
import 'package:th4/core/constants/currency_utils.dart';
import 'package:th4/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Logic for changing background can be handled here if needed deeper
          return true;
        },
        child: CustomScrollView(
          slivers: [
            // 1. SliverAppBar with Hero Image
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product-${product.id}',
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

          // 2. Product Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CurrencyUtils.formatVND(product.price * AppConstants.exchangeRate),
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${product.rating.rate}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' (${product.rating.count} đánh giá)',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),

                  // Description
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: product.description),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for Bottom Navigation
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Action Bar (Temporary as per Story 2.1 focus)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_outlined),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.4,
                      minChildSize: 0.2,
                      maxChildSize: 0.75,
                      expand: false,
                      builder: (context, scrollController) => SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.network(product.image, height: 80, width: 80, fit: BoxFit.contain),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(CurrencyUtils.formatVND(product.price * AppConstants.exchangeRate),
                                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              const Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  IconButton(onPressed: () {}, icon: const Icon(Icons.remove_circle_outline)),
                                  const Text('1'),
                                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Thêm thành công')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                                  child: const Text('Xác nhận'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
