import 'package:flutter/foundation.dart';
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
      'items': items,
    });

    notifyListeners();
  }
}
