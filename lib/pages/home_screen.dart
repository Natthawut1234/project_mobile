import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:project/pages/DeleteMenuPage.dart';
import 'package:project/pages/dashboard_screen.dart';
import 'package:project/pages/login.dart';
import 'package:project/pages/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/screen/AddMenuScreen.dart';
import 'menu_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // สร้างตัวแปรสำหรับจัดการข้อมูลที่เก็บใน secure storage
  final _storage = FlutterSecureStorage();

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    final token = await _storage.read(key: 'token');

    if (token != null) {
      const String apiUrl = "http://10.0.2.2:5000/api/auth/logout";

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );

        if (response.statusCode == 200) {
          await _storage.delete(key: 'token');

          if (mounted) {
            await CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              title: "ออกจากระบบสำเร็จ",
              text: "คุณได้ออกจากระบบแล้ว",
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            );
          }
        } else {
          if (mounted) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "เกิดข้อผิดพลาดในการออกจากระบบ!",
            );
          }
        }
      } catch (e) {
        if (mounted) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้!",
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> _confirmLogout() async {
    await CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "ยืนยันการออกจากระบบ",
      text: "คุณต้องการออกจากระบบหรือไม่?",
      confirmBtnText: "ตกลง",
      cancelBtnText: "ยกเลิก",
      showCancelBtn: true,
      confirmBtnColor: Colors.red, // 🔵 ปรับปุ่ม "ตกลง" เป็นสีฟ้า
      cancelBtnTextStyle:
          const TextStyle(color: Colors.black), // ⚫ ปรับ "ยกเลิก" เป็นสีดำ
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // ปิด CoolAlert ก่อน
        _logout(); // เรียก logout
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _confirmLogout, // ✅ เรียก Dialog ก่อนออกจากระบบ
          ),
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
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.white),
            backgroundColor: Colors.red,
            label: "ลบเมนู",
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DeleteMenuPage())),
          ),
          SpeedDialChild(
            child: const Icon(Icons.restaurant_menu, color: Colors.white),
            backgroundColor: Colors.green,
            label: "เพิ่มเมนู",
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddMenuScreen())),
          ),

          SpeedDialChild(
            child: const Icon(Icons.history, color: Colors.white),
            backgroundColor: Colors.orange,
            label: "ประวัติการสั่งซื้อ",
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage())),
          ),

          // deshboard
          SpeedDialChild(
            child: const Icon(Icons.dashboard, color: Colors.white),
            backgroundColor: Colors.blue,
            label: "Dashboard",
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen())),
          ),
        ],
      ),
    );
  }
}

// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:project/pages/DeleteMenuPage.dart';
// import 'package:project/pages/dashboard_screen.dart';
// import 'package:project/pages/login.dart';
// import 'package:project/pages/order_history.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../model/screen/AddMenuScreen.dart';
// import 'menu_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Future<void> _logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool("isLoggedIn", false);

//     CoolAlert.show(
//       context: context,
//       type: CoolAlertType.confirm,
//       title: "ออกจากระบบ",
//       text: "คุณต้องการออกจากระบบหรือไม่?",
//       confirmBtnText: "ใช่",
//       cancelBtnText: "ยกเลิก",
//       onConfirmBtnTap: () {
//         Navigator.pop(context); // ปิด CoolAlert
//         Future.delayed(const Duration(milliseconds: 300), () {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//             (Route<dynamic> route) => false,
//           );
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cafe ว้าดำ',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.lightBlue],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app, color: Colors.white),
//             onPressed: _logout,
//           ),
//         ],
//       ),

//       // Body
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Color(0xFFBBDEFB)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: MenuScreen(), // เพิ่มหน้าจอเมนูตรงนี้
//         // child: const Center(
//         //   child: Text(
//         //     "หน้าหลักแคชเชียร์",
//         //     style: TextStyle(
//         //         fontSize: 22,
//         //         fontWeight: FontWeight.bold,
//         //         color: Colors.black87),
//         //   ),
//         // ),
//       ),

//       // Floating Action Button (Speed Dial)
//       floatingActionButton: SpeedDial(
//         animatedIcon: AnimatedIcons.menu_close,
//         backgroundColor: Colors.blueAccent,
//         overlayColor: Colors.black,
//         overlayOpacity: 0.3,
//         children: [
//           SpeedDialChild(
//             child: const Icon(Icons.delete, color: Colors.white),
//             backgroundColor: Colors.red,
//             label: "ลบเมนู",
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => DeleteMenuPage())),
//           ),
//           SpeedDialChild(
//             child: const Icon(Icons.restaurant_menu, color: Colors.white),
//             backgroundColor: Colors.green,
//             label: "เพิ่มเมนู",
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => AddMenuScreen())),
//           ),

//           SpeedDialChild(
//             child: const Icon(Icons.history, color: Colors.white),
//             backgroundColor: Colors.orange,
//             label: "ประวัติการสั่งซื้อ",
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => OrderHistoryPage())),
//           ),

//           // deshboard
//           SpeedDialChild(
//             child: const Icon(Icons.dashboard, color: Colors.white),
//             backgroundColor: Colors.blue,
//             label: "Dashboard",
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => DashboardScreen())),
//           ),
//         ],
//       ),
//     );
//   }
// }
