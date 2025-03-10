import 'package:flutter/material.dart';
import 'package:project/model/menu_item.dart';
import 'package:provider/provider.dart';
import 'package:project/provider/order_history_provider.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderHistory = Provider.of<OrderHistoryProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติคำสั่งซื้อ')),
      body: orderHistory.isEmpty
          ? Center(
              child: Text(
                'ไม่มีประวัติคำสั่งซื้อ',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('คำสั่งซื้อ #${order['orderId']}'),
                    subtitle: Text('วันที่: ${order['date']}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('฿${order['total'].toStringAsFixed(2)}'),
                        Text('⭐ ${order['rating'].toStringAsFixed(1)}',
                            style: TextStyle(
                                color: Colors.orange)), // ✅ แสดงคะแนนดาว
                      ],
                    ),
                    onTap: () {
                      showReceiptDialog(context, order);
                    },
                  ),
                );
              },
            ),
    );
  }

  void showReceiptDialog(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ใบเสร็จ #${order['orderId']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('วันที่: ${order['date']}'),
                SizedBox(height: 10),

                // ✅ แปลง Map กลับเป็น MenuItem ก่อนแสดงผล
                Column(
                  children: List.generate(order['items'].length, (index) {
                    final Map<String, dynamic> itemMap = order['items'][index];
                    final MenuItem item =
                        MenuItem.fromMap(itemMap); // ✅ แปลงกลับเป็น MenuItem

                    return ListTile(
                      title: Text(item.name),
                      trailing: Text('฿${item.price.toStringAsFixed(2)}'),
                    );
                  }),
                ),

                Divider(),

                // ✅ แสดงราคารวม
                Text(
                  'รวมทั้งหมด: ฿${order['total'].toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // ✅ แสดงคะแนนที่ลูกค้าให้
                Text(
                  'คะแนนที่ให้: ⭐ ${order['rating'].toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 18, color: Colors.orange),
                ),
              ],
            ),
          ),
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
