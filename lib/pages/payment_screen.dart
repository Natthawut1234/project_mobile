import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/model/menu_item.dart';
import 'package:project/pages/receipt_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project/model/menu_item.dart';
import 'package:project/pages/receipt_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/provider/settings_provider.dart';

class PaymentQRCodeScreen extends StatefulWidget {
  final double totalAmount;
  final List<MenuItem> selectedItems;

  PaymentQRCodeScreen({
    required this.totalAmount,
    required this.selectedItems,
  });

  @override
  _PaymentQRCodeScreenState createState() => _PaymentQRCodeScreenState();
}

class _PaymentQRCodeScreenState extends State<PaymentQRCodeScreen> {
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 3));

  double rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ชำระเงินผ่าน QR Code')),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          String qrData = generatePromptPayQR(
              settingsProvider.phoneNumber, widget.totalAmount);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ยอดเงินที่ต้องชำระ: ฿${widget.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: widget.totalAmount > 0
                      ? () async {
                          _confettiController.play();
                          _showPaymentSuccessDialog();
                        }
                      : null,
                  child: Text('ยืนยันการชำระเงิน'),
                ),
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -1.5,
                  numberOfParticles: 20,
                  gravity: 0.2,
                ),
                SizedBox(height: 30),
                Text('ให้คะแนนบริการ'),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    String receiptId = DateTime.now().millisecondsSinceEpoch.toString();
    String paymentTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ชำระเงินสำเร็จ!"),
        content: Text("ขอบคุณสำหรับการใช้บริการ 😊"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceiptScreen(
                    selectedItems: widget.selectedItems,
                    receiptId: receiptId,
                    paymentTime: paymentTime,
                    rating: rating,
                  ),
                ),
              );
            },
            child: Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  String generatePromptPayQR(String phoneNumber, double amount) {
    if (phoneNumber.startsWith("0")) {
      phoneNumber = "0066" + phoneNumber.substring(1);
    }

    String formattedAmount = amount > 0 ? amount.toStringAsFixed(2) : "0.00";

    String data = "000201" + // Payload Format Indicator
        "010211" + // QR Static + PromptPay
        "29370016A000000677010111" + // PromptPay Merchant Account Information
        "0113$phoneNumber" + // เบอร์ PromptPay (ต้องเป็น 13 หลัก)
        "5303764" + // สกุลเงิน THB (764)
        (amount > 0
            ? "54${formattedAmount.length.toString().padLeft(2, '0')}$formattedAmount"
            : "") + // จำนวนเงิน (ถ้ามี)
        "5802TH" + // ประเทศไทย (TH)
        "6304"; // CRC16 Checksum Placeholder

    return data + calculateCRC16(data);
  }

// ✅ ฟังก์ชันคำนวณ CRC16 Checksum ตามมาตรฐาน EMVCo
  String calculateCRC16(String data) {
    int polynomial = 0x1021;
    int crc = 0xFFFF;

    for (int byte in data.codeUnits) {
      crc ^= (byte << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ polynomial;
        } else {
          crc <<= 1;
        }
      }
    }

    crc &= 0xFFFF;
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:project/model/menu_item.dart';
// import 'package:project/pages/receipt_page.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:confetti/confetti.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:convert/convert.dart';
// import 'package:crypto/crypto.dart';

// class PaymentQRCodeScreen extends StatefulWidget {
//   final double totalAmount; // รับค่าจาก MenuScreen
//   final List<MenuItem> selectedItems; // รับรายการที่เลือกมาแสดง
//   PaymentQRCodeScreen({
//     required this.totalAmount,
//     required this.selectedItems,
//   }); // Constructor

//   @override
//   _PaymentQRCodeScreenState createState() => _PaymentQRCodeScreenState();
// }

// class _PaymentQRCodeScreenState extends State<PaymentQRCodeScreen> {
//   final ConfettiController _confettiController =
//       ConfettiController(duration: Duration(seconds: 3));

//   double rating = 4.0; // ค่าเริ่มต้นของการให้คะแนน

//   // ฟังก์ชันสร้าง QR Code สำหรับ PromptPay
//   String generatePromptPayQR(String phoneNumber, double amount) {
//     String formattedAmount = amount > 0 ? amount.toStringAsFixed(2) : "0.00";

//     // แปลงเบอร์โทรศัพท์เป็นรูปแบบ 0066xxxxxxxxx
//     if (phoneNumber.startsWith("0")) {
//       phoneNumber = "0066" + phoneNumber.substring(1);
//     }

//     String data = "000201" + // Payload Format Indicator
//         "010211" + // QR Static และ PromptPay
//         "29370016A000000677010111" + // หมายเลขบัญชี PromptPay
//         "0113$phoneNumber" + // เบอร์โทร (ต้องเป็น 13 หลัก)
//         "5303764" + // สกุลเงิน (764 = THB)
//         (amount > 0
//             ? "54${formattedAmount.length.toString().padLeft(2, '0')}$formattedAmount"
//             : "") + // จำนวนเงิน
//         "5802TH" + // ประเทศไทย
//         "6304"; // CRC16 Checksum

//     // คำนวณค่า CRC16
//     String crc = calculateCRC16(data);
//     return data + crc;
//   }

// // ฟังก์ชันคำนวณ CRC16 ตามมาตรฐาน EMVCo
//   String calculateCRC16(String data) {
//     List<int> bytes =
//         List<int>.generate(data.length, (index) => data.codeUnitAt(index));

//     int polynomial = 0x1021;
//     int crc = 0xFFFF;

//     for (int byte in bytes) {
//       crc ^= (byte << 8);
//       for (int i = 0; i < 8; i++) {
//         if ((crc & 0x8000) != 0) {
//           crc = (crc << 1) ^ polynomial;
//         } else {
//           crc <<= 1;
//         }
//       }
//     }

//     crc &= 0xFFFF;
//     return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
//   }

//   // ฟังก์ชันแจ้งเตือนเมื่อชำระเงินเสร็จ
//   void _showPaymentSuccessDialog() {
//     String receiptId = DateTime.now().millisecondsSinceEpoch.toString();
//     String paymentTime =
//         DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("ชำระเงินสำเร็จ!"),
//         content: Text("ขอบคุณสำหรับการใช้บริการ 😊"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // ปิด Dialog
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ReceiptScreen(
//                     selectedItems: widget.selectedItems, // ✅ ส่งรายการสินค้า
//                     // totalAmount: widget.totalAmount, // ✅ ส่งยอดเงิน
//                     receiptId: receiptId, // ✅ ส่ง ID ใบเสร็จ
//                     paymentTime: paymentTime, // ✅ ส่งเวลา
//                     rating: rating, // ✅ ส่งค่าคะแนนดาวไปยัง ReceiptScreen
//                   ),
//                 ),
//               );
//             },
//             child: Text("ตกลง"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // String qrData = generatePromptPayQR("0989520103", widget.totalAmount);
//     String qrData = generatePromptPayQR("0924387042", widget.totalAmount);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ชำระเงินผ่าน QR Code'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // สรุปราคา
//             Text(
//               'ยอดเงินที่ต้องชำระ: ฿${widget.totalAmount.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),

//             // QR Code สำหรับ PromptPay
//             QrImageView(
//               data: qrData, // ใช้ข้อมูลที่สร้างจากฟังก์ชัน
//               version: QrVersions.auto,
//               size: 200.0, // ขนาด QR Code
//             ),

//             SizedBox(height: 20),

//             // ปุ่มยืนยันการจ่ายเงิน พร้อม Confetti Animation
//             ElevatedButton(
//               onPressed: widget.totalAmount > 0
//                   ? () async {
//                       _confettiController.play();

//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ReceiptScreen(
//                             selectedItems: widget.selectedItems,
//                             receiptId: DateTime.now()
//                                 .millisecondsSinceEpoch
//                                 .toString(),
//                             paymentTime: DateFormat('yyyy-MM-dd HH:mm:ss')
//                                 .format(DateTime.now()),
//                             rating:
//                                 rating, // ✅ ส่งค่าคะแนนดาวไปยัง ReceiptScreen
//                           ),
//                         ),
//                       );

//                       if (result == true) {
//                         setState(() {}); // ✅ รีเฟรชหน้า
//                       }
//                     }
//                   : null, // ปิดปุ่มถ้ายอดเงินเป็น 0
//               child: Text('ยืนยันการชำระเงิน'),
//             ),

//             // Confetti Animation
//             ConfettiWidget(
//               confettiController: _confettiController,
//               blastDirection: -1.5, // ยิงขึ้นด้านบน
//               numberOfParticles: 20,
//               gravity: 0.2,
//             ),

//             SizedBox(height: 30),

//             // Stars Rating Bar
//             Text('ให้คะแนนบริการ'),
//             RatingBar.builder(
//               initialRating: rating,
//               minRating: 0.5,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemBuilder: (context, _) => Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (newRating) {
//                 setState(() {
//                   rating = newRating;
//                 });
//                 print('ให้คะแนน: $newRating');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
