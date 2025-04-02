import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/pages/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController =
      TextEditingController(); // ใช้ _usernameController
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // ป้องกันการกดซ้ำ

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    String username = _usernameController.text.trim(); // เก็บค่าชื่อผู้ใช้
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    var url =
        "http://10.0.2.2:5000/api/auth/register"; // URL สำหรับการสมัครสมาชิก
    var body = json.encode({
      'username': username,
      'email': email,
      'password': password
    }); // ส่ง username

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      var responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "สมัครสมาชิกสำเร็จ",
          text: "กรุณาเข้าสู่ระบบด้วยอีเมลและรหัสผ่านของคุณ",
          autoCloseDuration: const Duration(seconds: 2),
        );
        Navigator.pop(context); // กลับไปที่หน้า login
      } else {
        String errorMessage = responseData["message"] ?? "เกิดข้อผิดพลาด";
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "สมัครสมาชิกไม่สำเร็จ",
          text: errorMessage,
        );
      }
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองใหม่อีกครั้ง",
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_open,
                          size: 80, color: Colors.white),
                      const SizedBox(height: 10),
                      const Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // เพิ่มช่องกรอกชื่อผู้ใช้
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "ชื่อผู้ใช้",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณากรอกชื่อผู้ใช้";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
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
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณากรอกอีเมล";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "รหัสผ่าน",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณากรอกรหัสผ่าน";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "ยืนยันรหัสผ่าน",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "รหัสผ่านไม่ตรงกัน";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue.shade900,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                "สมัครสมาชิก",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      //มีบัญชีอยู่แล้ว? เข้าสู่ระบบ
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("มีบัญชีอยู่แล้ว? ",
                              style: TextStyle(color: Colors.white)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
