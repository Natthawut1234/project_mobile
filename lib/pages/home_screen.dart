import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart'; // ใช้ Speed Dial
import 'package:project/pages/cashier_screen.dart';
import 'package:project/pages/order_history.dart';
import 'package:project/pages/payment_screen.dart';
import 'package:project/pages/review_screen.dart';
import '../model/screen/AddMenuScreen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: const Text('Cafe ว้าดำ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.list),
          )
        ],
      ),

      // Body
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: MenuScreen(), // เพิ่มหน้าจอเมนูตรงนี้
        // child: const Center(
        //   child: Text(
        //     "หน้าหลักแคชเชียร์",
        //     style: TextStyle(
        //         fontSize: 22,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black87),
        //   ),
        // ),
      ),

      // Floating Action Button (Speed Dial)
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blueAccent,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        children: [
          // SpeedDialChild(
          //   child: const Icon(Icons.qr_code, color: Colors.white),
          //   backgroundColor: Colors.green,
          //   label: "ชำระเงิน",
          //   onTap: () => Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => PaymentQRCodeScreen())),
          // ),
          // SpeedDialChild(
          //   child: const Icon(Icons.star, color: Colors.white),
          //   backgroundColor: Colors.amber,
          //   label: "รีวิวร้านค้า",
          //   onTap: () => Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => const ReviewScreen())),
          // ),
          SpeedDialChild(
            child: const Icon(Icons.restaurant_menu, color: Colors.white),
            backgroundColor: Colors.redAccent,
            label: "เพิ่มเมนู",
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddMenuScreen(
                          onAddMenu: (MenuItem) {},
                        ))),
          ),
          SpeedDialChild(
            child: const Icon(Icons.menu, color: Colors.white),
            backgroundColor: Colors.orange,
            label: "เมนู",
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuScreen())),
          ),
          // SpeedDialChild(
          //   child: const Icon(Icons.home, color: Colors.white),
          //   backgroundColor: Colors.grey,
          //   label: "หน้าหลัก",
          //   onTap: () => Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => CashierScreen())),
          // ),
          SpeedDialChild(
            child: const Icon(Icons.history, color: Colors.white),
            backgroundColor: Colors.green,
            label: "ประวัติการสั่งซื้อ",
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage())),
          ),
        ],
      ),
    );
  }
}
