import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PaymentQRCodeScreen extends StatefulWidget {
  final double totalAmount;  // รับค่าจาก MenuScreen

  PaymentQRCodeScreen({required this.totalAmount});  // เพิ่ม constructor
  @override
  _PaymentQRCodeScreenState createState() => _PaymentQRCodeScreenState();
}

class _PaymentQRCodeScreenState extends State<PaymentQRCodeScreen> {
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 3));

  // ข้อมูลสำหรับ PromptPay (หมายเลขโทรศัพท์)
  String promptPayData =
      "00020101021129390016A000000677010111031500499910514827353037645802TH630469EE";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชำระเงินผ่าน QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // สรุปราคา
            Text(
              'ยอดเงินที่ต้องชำระ: ฿${widget.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // QR Code สำหรับ PromptPay
            QrImageView(
              data: promptPayData, // ใช้ข้อมูล PromptPay
              version: QrVersions.auto,
              size: 200.0, // ขนาด QR Code
            ),

            SizedBox(height: 20),

            // ปุ่มยืนยันการจ่ายเงิน พร้อม Confetti Animation
            ElevatedButton(
              onPressed: () {
                _confettiController.play();
              },
              child: Text('ยืนยันการชำระเงิน'),
            ),

            // Confetti Animation
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -1.5, // ยิงขึ้นด้านบน
              numberOfParticles: 20,
              gravity: 0.2,
            ),

            SizedBox(height: 30),

            // Stars Rating Bar
            Text('ให้คะแนนบริการ'),
            RatingBar.builder(
              initialRating: 4,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print('ให้คะแนน: $rating');
              },
            ),
          ],
        ),
      ),
    );
  }
}
