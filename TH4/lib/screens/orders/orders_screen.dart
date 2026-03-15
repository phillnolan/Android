import 'package:flutter/material.dart';
import 'package:th4/widgets/orders/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn mua'),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderList(status: 'pending'),
            OrderList(status: 'shipping'),
            OrderList(status: 'delivered'),
            OrderList(status: 'cancelled'),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final String status;

  const OrderList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockOrders = _getMockOrders(status);

    if (mockOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Chưa có đơn hàng nào',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mockOrders.length,
      itemBuilder: (context, index) {
        return OrderCard(order: mockOrders[index]);
      },
    );
  }

  List<Map<String, dynamic>> _getMockOrders(String status) {
    if (status == 'delivered') {
      return [
        {
          'id': 'ORD123456',
          'date': '14/03/2026',
          'amount': 550000.0,
          'statusText': 'Đã giao',
          'items': 'Laptop Dell XPS, Chuột Logitech'
        },
        {
          'id': 'ORD123457',
          'date': '12/03/2026',
          'amount': 120000.0,
          'statusText': 'Đã giao',
          'items': 'Tai nghe Sony WH-1000XM4'
        },
      ];
    } else if (status == 'shipping') {
      return [
        {
          'id': 'ORD789012',
          'date': '15/03/2026',
          'amount': 250000.0,
          'statusText': 'Đang giao',
          'items': 'Bàn phím cơ Keychron K2'
        },
      ];
    }
    return [];
  }
}
