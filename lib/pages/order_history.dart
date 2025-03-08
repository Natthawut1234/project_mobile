// history.dart
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  // สมมติว่าเรามีข้อมูลคำสั่งซื้อในรูปแบบ List
  final List<Map<String, dynamic>> orders = [
    {'orderId': '123', 'date': '2025-03-01', 'total': 500},
    {'orderId': '124', 'date': '2025-02-28', 'total': 300},
    // เพิ่มรายการคำสั่งซื้อที่เหลือที่นี่
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติคำสั่งซื้อ')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('คำสั่งซื้อ #${order['orderId']}'),
              subtitle: Text('วันที่: ${order['date']}'),
              trailing: Text('฿${order['total']}'),
              onTap: () {
                // แสดงใบเสร็จย้อนหลัง
                showReceiptDialog(context, order['orderId']);
              },
            ),
          );
        },
      ),
    );
  }

  void showReceiptDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ใบเสร็จย้อนหลัง'),
          content: Text('แสดงใบเสร็จสำหรับคำสั่งซื้อ #$orderId'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }
}
