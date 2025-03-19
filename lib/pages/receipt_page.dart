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
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle; //ใช้โหลดฟอนต์

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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Center(child: Text('🧾 ใบเสร็จจาก ว้าดำ Cafe')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...selectedItems.map((item) => Text(
                              '${item.name}: ฿${item.price.toStringAsFixed(2)}')),
                          SizedBox(height: 10),
                          Text(
                            'รวมทั้งหมด: ฿${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text('ขอบคุณที่ใช้บริการ❤️'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('ตกลง'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Generate and download PDF
                            await _generateAndDownloadReceiptPDF(selectedItems,
                                totalAmount, receiptId, paymentTime, rating);
                          },
                          child: Text('ดาวน์โหลดใบเสร็จ'),
                        ),
                      ],
                    ),
                  );
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
Future<void> _generateAndDownloadReceiptPDF(
    List<MenuItem> selectedItems,
    double totalAmount,
    String receiptId,
    String paymentTime,
    double rating) async {
  final pdf = pw.Document();

  // ✅ โหลดฟอนต์ภาษาไทย
  // final fontData =
  //     await rootBundle.load("assets/fonts/NotoSansThai-Regular.ttf");
  // final ttf = pw.Font.ttf(fontData);
  // // Add receipt content to PDF
  // pdf.addPage(
  //   pw.Page(
  //     build: (pw.Context context) {
  //       return pw.Column(
  //         children: [
  //           pw.Text('ว้าดำ Cafe',
  //               style: pw.TextStyle(
  //                   fontSize: 22, fontWeight: pw.FontWeight.bold, font: ttf)),
  //           pw.Divider(),
  //           pw.Text('ID ใบเสร็จ: $receiptId',
  //               style: pw.TextStyle(fontSize: 16, font: ttf)),
  //           pw.Text('วันที่และเวลา: $paymentTime',
  //               style: pw.TextStyle(fontSize: 16, font: ttf)),
  //           pw.Divider(),
  //           pw.Column(
  //             children: selectedItems.map((item) {
  //               return pw.Row(
  //                 children: [
  //                   pw.Text(item.name,
  //                       style: pw.TextStyle(fontSize: 18, font: ttf)),
  //                   pw.Spacer(),
  //                   pw.Text('฿${item.price.toStringAsFixed(2)}',
  //                       style: pw.TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: pw.FontWeight.bold,
  //                           font: ttf)),
  //                 ],
  //               );
  //             }).toList(),
  //           ),
  //           pw.Divider(),
  //           pw.Text('คะแนนที่ให้: ⭐ ${rating.toStringAsFixed(1)}',
  //               style: pw.TextStyle(
  //                   fontSize: 18, color: PdfColors.orange, font: ttf)),
  //           pw.SizedBox(height: 5),
  //           pw.Text('รวมทั้งหมด: ฿${totalAmount.toStringAsFixed(2)}',
  //               style: pw.TextStyle(
  //                   fontSize: 20, fontWeight: pw.FontWeight.bold, font: ttf)),
  //           pw.Divider(),
  //           pw.Text('ขอบคุณที่ใช้บริการ ว้าดำ Cafe ❤️',
  //               style: pw.TextStyle(
  //                   fontSize: 16, fontStyle: pw.FontStyle.italic, font: ttf)),
  //         ],
  //       );
  //     },
  //   ),
  // );

  // ✅ โหลดฟอนต์ภาษาไทย
  final fontThai =
      pw.Font.ttf(await rootBundle.load("assets/fonts/THSarabunNew.ttf"));

  // ✅ โหลดฟอนต์อิโมจิ (Noto Emoji)
  final fontEmoji = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoEmoji-VariableFont_wght.ttf"));

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ส่วนหัวของร้านกาแฟ
            pw.Center(
              child: pw.Text('ว้าดำ Cafe',
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      font: fontThai)),
            ),
            pw.Divider(),

            // ข้อมูลใบเสร็จ
            pw.Center(
              child: pw.Text('ID ใบเสร็จ: $receiptId',
                  style: pw.TextStyle(fontSize: 18, font: fontThai)),
            ),
            pw.Center(
              child: pw.Text('วันที่และเวลา: $paymentTime',
                  style: pw.TextStyle(fontSize: 18, font: fontThai)),
            ),
            pw.Divider(),

            // รายการสินค้า
            pw.Column(
              children: selectedItems.map((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(item.name,
                        style: pw.TextStyle(fontSize: 18, font: fontThai)),
                    pw.Text('฿${item.price.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            font: fontThai)),
                  ],
                );
              }).toList(),
            ),
            pw.Divider(),

            // คะแนนที่ให้ ⭐
            pw.Center(
              child: pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                pw.Text('คะแนนที่ให้: ',
                    style: pw.TextStyle(
                        fontSize: 18, color: PdfColors.orange, font: fontThai)),
                pw.Text('⭐',
                    style: pw.TextStyle(fontSize: 10, font: fontEmoji)),
                pw.Text(' ${rating.toStringAsFixed(1)}',
                    style: pw.TextStyle(
                        fontSize: 18, color: PdfColors.orange, font: fontThai)),
              ]),
            ),
            pw.SizedBox(height: 10),

            // จำนวนเงินรวม
            pw.Center(
              child: pw.Text('รวมทั้งหมด: ฿${totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      font: fontThai)),
            ),
            pw.Divider(),

            // ข้อความขอบคุณ
            pw.Center(
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text('🙏',
                      style: pw.TextStyle(fontSize: 18, font: fontEmoji)),
                  pw.Text('ขอบคุณที่ใช้บริการ ว้าดำ Cafe',
                      style: pw.TextStyle(
                          fontSize: 18,
                          fontStyle: pw.FontStyle.italic,
                          font: fontThai)),
                  pw.Text('❤️',
                      style: pw.TextStyle(fontSize: 18, font: fontEmoji)),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  // Save the PDF and share it
  final pdfBytes = await pdf.save();
  await Printing.sharePdf(bytes: pdfBytes, filename: 'receipt.pdf');
}
