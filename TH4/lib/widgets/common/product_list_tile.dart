import 'package:flutter/material.dart';
import 'package:th4/l10n/app_localizations.dart';
import 'package:th4/core/constants/app_constants.dart';
import 'package:th4/core/constants/currency_utils.dart';
import 'package:th4/models/product_model.dart';

class ProductListTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Hero(
                tag: 'product-${product.id}',
                child: Image.network(
                  product.image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyUtils.formatVND(product.price * AppConstants.exchangeRate),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          ' ${product.rating.rate}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          '${l10n.sold} ${product.rating.count}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
