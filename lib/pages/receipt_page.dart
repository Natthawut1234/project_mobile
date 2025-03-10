import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/model/menu_item.dart';
import 'package:project/pages/home_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:project/provider/list_menu.dart';
import 'package:project/provider/order_history_provider.dart';
import 'package:provider/provider.dart'; // ✅ ใช้เปิดไฟล์ PDF

class ReceiptScreen extends StatelessWidget {
  final List<MenuItem> selectedItems;
  final String receiptId;
  final String paymentTime;
  final double rating; // ✅ รับค่าคะแนนดาวจาก payment_screen.dart

  ReceiptScreen({
    required this.selectedItems,
    required this.receiptId,
    required this.paymentTime,
    required this.rating, // ✅ เพิ่ม rating
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = calculateTotal(selectedItems);

    return Scaffold(
      appBar: AppBar(title: Text('ใบเสร็จ')),
      body: Column(
        children: [
          Text('ID ใบเสร็จ: $receiptId'),
          Text('วันที่และเวลา: $paymentTime'),
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('ราคา: ฿${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Text(
            'คะแนนที่ให้: ⭐ ${rating.toStringAsFixed(1)}', // ✅ แสดงคะแนนดาวที่ลูกค้าให้
            style: TextStyle(fontSize: 18, color: Colors.orange),
          ),
          Text(
            'รวมทั้งหมด: ฿${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // ✅ ปุ่ม "พิมพ์ใบเสร็จ" และ "เสร็จสิ้น"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // String? filePath = await createPDF(
                  //     selectedItems, totalAmount, receiptId, paymentTime);
                  // if (filePath != null) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('บันทึกใบเสร็จสำเร็จ: $filePath')),
                  //   );
                  //   OpenFile.open(filePath); // ✅ เปิดไฟล์ PDF อัตโนมัติ
                  // }
                },
                child: Text('พิมพ์ใบเสร็จ'),
              ),
              ElevatedButton(
                onPressed: () {
                  // บันทึกคำสั่งซื้อไปที่ OrderHistoryProvider
                  Provider.of<OrderHistoryProvider>(context, listen: false)
                      .addOrder(
                    receiptId,
                    paymentTime,
                    totalAmount,
                    rating, // ✅ ส่งคะแนนดาวไปด้วย
                    selectedItems,

                  );
                  // เคลียร์ตะกร้า
                  Provider.of<ListMenu>(context, listen: false).clearCart();
                  // ✅ กลับไปที่ HomeScreen โดยล้าง Stack ทั้งหมด
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false, // ลบทุกหน้าออกจาก Stack
                  );
                },
                child: Text("เสร็จสิ้น"),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ✅ ฟังก์ชันคำนวณยอดรวม
double calculateTotal(List<MenuItem> selectedItems) {
  return selectedItems.fold(0.0, (sum, item) => sum + item.price);
}

// // ✅ ฟังก์ชันสร้าง PDF (ขอ permission และบันทึกไฟล์)
// Future<String?> createPDF(List<MenuItem> items, double totalAmount,
//     String receiptId, String paymentTime) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text("ใบเสร็จ",
//               style:
//                   pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Text("ID ใบเสร็จ: $receiptId"),
//           pw.Text("วันที่และเวลา: $paymentTime"),
//           pw.SizedBox(height: 10),
//           pw.Text("รายการสินค้า:",
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//           ...items.map((item) =>
//               pw.Text("${item.name} - ฿${item.price.toStringAsFixed(2)}")),
//           pw.Divider(),
//           pw.Text("รวมทั้งหมด: ฿${totalAmount.toStringAsFixed(2)}",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//         ],
//       ),
//     ),
//   );

//   // ✅ ขอ permission
//   if (!(await Permission.storage.request().isGranted)) {
//     print("Permission denied");
//     return null;
//   }

//   final directory = await getApplicationDocumentsDirectory();
//   final filePath = "${directory.path}/receipt_$receiptId.pdf";
//   final file = File(filePath);

//   await file.writeAsBytes(await pdf.save());

//   print("PDF บันทึกที่: $filePath");
//   return filePath; // ✅ ส่ง path กลับไปเพื่อเปิดไฟล์
// }
