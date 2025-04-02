import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/pages/RegisterScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:project/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    var url = "http://10.0.2.2:5000/api/auth/login";
    var body = json.encode({'email': email, 'password': password});

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        String name = responseData["user"]["username"] ?? "ผู้ใช้";
        String email = responseData["user"]["email"];

        print("✅ ชื่อที่ได้จาก API: $name"); // ✅ Debugging

        Provider.of<SettingsProvider>(context, listen: false)
            .setUserData(name, email, password);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('password', password);

        // ตรวจสอบค่าที่บันทึก
        print("🔹 บันทึกลง SharedPreferences แล้ว: ${prefs.getString('name')}");

        await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "เข้าสู่ระบบสำเร็จ",
          text: "ยินดีต้อนรับ $name!",
          autoCloseDuration: const Duration(seconds: 2),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "เข้าสู่ระบบไม่สำเร็จ",
          text: responseData["message"] ?? "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
        );
      }
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองใหม่",
      );
    }

    setState(() => isLoading = false);
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
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
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
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "กรุณากรอกอีเมล" : null,
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
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "กรุณากรอกรหัสผ่าน" : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue.shade900,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text("เข้าสู่ระบบ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "ยังไม่มีบัญชี? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "สมัครสมาชิก",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
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

// import 'dart:convert';
// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project/pages/RegisterScreen.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false; // 🔄 ตัวแปรป้องกันการกดซ้ำ

//   Future<void> login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//     });

//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     var url = "http://10.0.2.2:5000/api/auth/login";
//     var body = json.encode({'email': email, 'password': password});

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: body,
//       );

//       var responseData = json.decode(response.body);
//       if (response.statusCode == 200) {
//         // ✅ แสดงแจ้งเตือนก่อนเปลี่ยนหน้า
//         await CoolAlert.show(
//           context: context,
//           type: CoolAlertType.success,
//           title: "เข้าสู่ระบบสำเร็จ",
//           text: "ยินดีต้อนรับ!",
//           autoCloseDuration: const Duration(seconds: 2),
//         );

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         }
//       } else {
//         String errorMessage =
//             responseData["message"] ?? "กรุณาตรวจสอบอีเมลหรือรหัสผ่านอีกครั้ง";
//         CoolAlert.show(
//           context: context,
//           type: CoolAlertType.error,
//           title: "เข้าสู่ระบบไม่สำเร็จ",
//           text: errorMessage,
//         );
//       }
//     } catch (e) {
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.error,
//         title: "เกิดข้อผิดพลาด",
//         text: "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองใหม่อีกครั้ง",
//       );
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset("assets/images/background.jpg", fit: BoxFit.cover),
//           Container(color: Colors.black.withOpacity(0.4)),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.5)),
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.lock_open,
//                           size: 80, color: Colors.white),
//                       const SizedBox(height: 10),
//                       const Text(
//                         "เข้าสู่ระบบ",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                           labelText: "อีเมล",
//                           labelStyle: const TextStyle(color: Colors.white),
//                           prefixIcon:
//                               const Icon(Icons.email, color: Colors.white),
//                           filled: true,
//                           fillColor: Colors.white.withOpacity(0.1),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "กรุณากรอกอีเมล";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 15),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                           labelText: "รหัสผ่าน",
//                           labelStyle: const TextStyle(color: Colors.white),
//                           prefixIcon:
//                               const Icon(Icons.lock, color: Colors.white),
//                           filled: true,
//                           fillColor: Colors.white.withOpacity(0.1),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "กรุณากรอกรหัสผ่าน";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: isLoading ? null : login,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 40),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor: Colors.blue.shade900,
//                         ),
//                         child: isLoading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                     color: Colors.white, strokeWidth: 2),
//                               )
//                             : const Text(
//                                 "เข้าสู่ระบบ",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("ยังไม่มีบัญชี? ",
//                               style: TextStyle(color: Colors.white)),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const RegisterScreen()),
//                               );
//                             },
//                             child: const Text(
//                               "สมัครสมาชิก",
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/material.dart';
// import 'package:project/pages/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future<void> _login() async {
//     if (_emailController.text == "admin" &&
//         _passwordController.text == "1234") {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setBool("isLoggedIn", true);
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.success,
//         text: "เข้าสู่ระบบสำเร็จ!",
//         onConfirmBtnTap: () {
//           Navigator.pop(context); // ปิด CoolAlert
//           Future.delayed(const Duration(milliseconds: 300), () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//               (Route<dynamic> route) => false,
//             );
//           });
//         },
//       );
//     } else {
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.error,
//         text: "อีเมลหรือรหัสผ่านไม่ถูกต้อง!",
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // พื้นหลังรูปภาพ
//           Image.asset(
//             "assets/images/background.jpg", // เปลี่ยนเป็น path ของรูปภาพที่คุณต้องการ
//             fit: BoxFit.cover,
//           ),

//           // เลเยอร์สีดำโปร่งแสงเพื่อให้ข้อความเด่นขึ้น
//           Container(
//             color: Colors.black.withOpacity(0.4),
//           ),

//           // กล่องล็อกอินแบบโปร่งแสง
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2), // สีโปร่งแสง
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.5)), // ขอบโปร่งแสง
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.lock_open, size: 80, color: Colors.white),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "เข้าสู่ระบบจัดการคาเฟ่ว้าดำ",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: _emailController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: "อีเมล",
//                         labelStyle: const TextStyle(color: Colors.white),
//                         prefixIcon:
//                             const Icon(Icons.email, color: Colors.white),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.1),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     TextField(
//                       controller: _passwordController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: "รหัสผ่าน",
//                         labelStyle: const TextStyle(color: Colors.white),
//                         prefixIcon: const Icon(Icons.lock, color: Colors.white),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.1),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.white),
//                         ),
//                       ),
//                       obscureText: true,
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         backgroundColor: Colors.blue.shade900,
//                       ),
//                       child: const Text(
//                         "เข้าสู่ระบบ",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
