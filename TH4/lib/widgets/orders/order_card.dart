import 'package:flutter/material.dart';
import 'package:th4/core/constants/currency_utils.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mã đơn: ${order['id']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  order['statusText'],
                  style: TextStyle(
                    color: _getStatusColor(order['statusText']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              order['items'],
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ngày đặt: ${order['date']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                Text(
                  'Tổng: ${CurrencyUtils.formatVND(order['amount'])}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                ),
                child: const Text('Mua lại'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã giao':
        return Colors.green;
      case 'Đang giao':
        return Colors.blue;
      case 'Đã hủy':
        return Colors.red;
      case 'Chờ xác nhận':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}
