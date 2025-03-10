import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_emailController.text == "admin" &&
        _passwordController.text == "1234") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "เข้าสู่ระบบสำเร็จ!",
        onConfirmBtnTap: () {
          Navigator.pop(context); // ปิด CoolAlert
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          });
        },
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "อีเมลหรือรหัสผ่านไม่ถูกต้อง!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // พื้นหลังรูปภาพ
          Image.asset(
            "assets/images/background.jpg", // เปลี่ยนเป็น path ของรูปภาพที่คุณต้องการ
            fit: BoxFit.cover,
          ),

          // เลเยอร์สีดำโปร่งแสงเพื่อให้ข้อความเด่นขึ้น
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // กล่องล็อกอินแบบโปร่งแสง
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // สีโปร่งแสง
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.5)), // ขอบโปร่งแสง
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_open, size: 80, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      "เข้าสู่ระบบจัดการคาเฟ่ว้าดำ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "อีเมล",
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "รหัสผ่าน",
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: const Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
