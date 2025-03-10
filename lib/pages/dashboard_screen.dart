import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/provider/order_history_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderHistory = Provider.of<OrderHistoryProvider>(context);
    final todaySummary = orderHistory.getTodaySummary();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard การขายวันนี้'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 สรุปยอดขายวันนี้',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // ✅ แสดงสถิติยอดขาย
            Card(
              color: Colors.green[100],
              child: ListTile(
                title: Text(
                    '🛍 จำนวนออเดอร์ทั้งหมด: ${todaySummary['totalOrders']} ออเดอร์'),
                subtitle: Text(
                    '🥤 จำนวนแก้วที่ขาย: ${todaySummary['totalItemsSold']} แก้ว'),
                trailing: Text(
                  '💰 รวมเงิน: ${todaySummary['totalRevenue'].toStringAsFixed(2)} บาท',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              '📌 รายการสินค้าที่ขาย:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // ✅ แสดงรายการสินค้าที่ขาย
            Expanded(
              child: todaySummary['itemsCount'].isEmpty
                  ? Center(child: Text("ยังไม่มีรายการขายวันนี้"))
                  : ListView(
                      children: todaySummary['itemsCount']
                          .entries
                          .map<Widget>((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Text('🛒 ขายได้: ${entry.value} ชิ้น'),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
