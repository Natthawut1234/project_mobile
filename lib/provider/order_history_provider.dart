import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:project/model/menu_item.dart';

class OrderHistoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  void addOrder(String orderId, String date, double total, double rating,
      List<MenuItem> items) {
    _orders.add({
      'orderId': orderId,
      'date': date,
      'total': total,
      'rating': rating, // ✅ เพิ่มคะแนนดาวลงในประวัติ
      'items': items.map((item) => item.toMap()).toList(), // ✅ แปลง MenuItem เป็น Map ก่อนบันทึก
    });

    notifyListeners();
  }

  // ✅ ดึงข้อมูลเฉพาะของวันนี้
  List<Map<String, dynamic>> getTodayOrders() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _orders.where((order) => order['date'].startsWith(today)).toList();
  }

  Map<String, dynamic> getTodaySummary() {
    List<Map<String, dynamic>> todayOrders = getTodayOrders();

    int totalOrders = 0;
    int totalItemsSold = 0;
    // int totalGlassesSold = 0;
    double totalRevenue = 0.0;
    Map<String, int> itemsCount = {};

    for (var order in todayOrders) {
      totalOrders++;
      totalRevenue += order['total'];

      for (var itemMap in order['items']) {
        final MenuItem item = MenuItem.fromMap(itemMap);
        totalItemsSold++;
        // if (item.name.contains("แก้ว")) {
        //   totalGlassesSold++;
        // }

        itemsCount[item.name] = (itemsCount[item.name] ?? 0) + 1;
      }
    }

    return {
      'totalOrders': totalOrders, // จำนวนออเดอร์ทั้งหมด
      'totalItemsSold': totalItemsSold, // จำนวนรายการสินค้าทั้งหมด
      // 'totalGlassesSold': totalGlassesSold, // จำนวนแก้วที่ขายไป
      'totalRevenue': totalRevenue, // รายได้ทั้งหมด
      'itemsCount': itemsCount, // จำนวนของแต่ละรายการ
    };
  }
}