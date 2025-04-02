import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Removed unused import
import 'package:shared_preferences/shared_preferences.dart';

// Provider สำหรับเก็บข้อมูลผู้ใช้
class SettingsProvider extends ChangeNotifier {
  String _name = "";
  String _email = "";
  String _password = "";
  String _phoneNumber = "0924387042";

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get phoneNumber => _phoneNumber;

  void setUserData(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("password", password);

    _name = name; // ✅ ตั้งค่าตัวแปรใหม่ตรงนี้
    _email = email;
    _password = password;

    notifyListeners(); // ✅ แจ้ง UI ให้อัปเดต
  }

  SettingsProvider() {
    _loadData().then((_) {
      notifyListeners(); // ✅ แจ้งให้ UI โหลดค่าล่าสุด
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name") ?? "";
    _email = prefs.getString("email") ?? "";
    _password = prefs.getString("password") ?? "";
    _phoneNumber = prefs.getString("phoneNumber") ?? "0924387042";
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _name = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", newName);
    notifyListeners();
  }

  Future<void> updateEmail(String newEmail) async {
    _email = newEmail;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", newEmail);
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    _password = newPassword;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("password", newPassword);
    notifyListeners();
  }

  Future<void> updatePhone(String newPhone) async {
    _phoneNumber = newPhone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("phoneNumber", newPhone);
    notifyListeners();
  }
}

// Settings Screen
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;

  bool isEditingPhone = false;
  bool showPassword = false; // ควบคุมการแสดงรหัสผ่าน

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<SettingsProvider>(context, listen: false);
    nameController = TextEditingController(text: userProvider.name);
    emailController = TextEditingController(text: userProvider.email);
    passwordController = TextEditingController(text: userProvider.password);
    phoneController = TextEditingController(text: userProvider.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ฟังก์ชันแสดง Dialog เพื่อยืนยันรหัสผ่านก่อนดู
  Future<void> _showPasswordConfirmationDialog(
      BuildContext context, SettingsProvider userProvider) async {
    final confirmationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ยืนยันรหัสผ่าน"),
          content: TextField(
            controller: confirmationController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "กรุณาใส่รหัสผ่าน",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                if (confirmationController.text == userProvider.password) {
                  setState(() {
                    showPassword = true; // อนุญาตให้เห็นรหัสผ่าน
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("รหัสผ่านไม่ถูกต้อง"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("ยืนยัน"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("การตั้งค่า")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username Field (ดูได้อย่างเดียว)
            TextField(
              controller: nameController,
              enabled: false, // ไม่สามารถแก้ไขได้
              decoration: const InputDecoration(labelText: "ชื่อผู้ใช้"),
            ),
            const SizedBox(height: 10),

            // Email Field (ดูได้อย่างเดียว)
            TextField(
              controller: emailController,
              enabled: false, // ไม่สามารถแก้ไขได้
              decoration: const InputDecoration(labelText: "อีเมล"),
            ),
            const SizedBox(height: 10),

            // Password Field (สามารถกดดูรหัสผ่านได้ แต่ไม่สามารถแก้ไขได้)
            // TextField(
            //   controller: passwordController,
            //   enabled: false, // ไม่สามารถแก้ไขได้
            //   obscureText: !showPassword, // ซ่อนหรือแสดงรหัสผ่าน
            //   decoration: InputDecoration(
            //     labelText: "รหัสผ่าน",
            //     suffixIcon: IconButton(
            //       icon: Icon(
            //         showPassword ? Icons.visibility : Icons.visibility_off,
            //       ),
            //       onPressed: () {
            //         if (!showPassword) {
            //           // ถ้ารหัสยังไม่แสดง ให้เรียก Dialog
            //           _showPasswordConfirmationDialog(context, userProvider);
            //         } else {
            //           setState(() {
            //             showPassword = false; // ซ่อนรหัสผ่านเมื่อกดอีกครั้ง
            //           });
            //         }
            //       },
            //     ),
            //   ),
            // ),

            const SizedBox(height: 10),

            // Phone Number Field (แก้ไขได้)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    enabled: isEditingPhone, // เปิดใช้งานเมื่ออยู่ในโหมดแก้ไข
                    decoration:
                        const InputDecoration(labelText: "หมายเลข PromptPay "),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => userProvider.updatePhone(value),
                  ),
                ),
                IconButton(
                  icon: Icon(isEditingPhone ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (isEditingPhone) {
                      userProvider.updatePhone(
                          phoneController.text); // บันทึกหมายเลขโทรศัพท์ใหม่
                    }
                    setState(() {
                      isEditingPhone = !isEditingPhone; // สลับโหมดแก้ไข
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // Removed unused import
// import 'package:shared_preferences/shared_preferences.dart';

// // Provider สำหรับเก็บข้อมูลผู้ใช้
// class SettingsProvider extends ChangeNotifier {
//   String _name = "";
//   String _email = "";
//   String _password = "";
//   String _phoneNumber = "0924387042";

//   String get name => _name;
//   String get email => _email;
//   String get password => _password;
//   String get phoneNumber => _phoneNumber;

//   void setUserData(String name, String email, String password) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("name", name);
//     await prefs.setString("email", email);
//     await prefs.setString("password", password);

//     _name = name; // ✅ ตั้งค่าตัวแปรใหม่ตรงนี้
//     _email = email;
//     _password = password;

//     notifyListeners(); // ✅ แจ้ง UI ให้อัปเดต
//   }

//   SettingsProvider() {
//     _loadData().then((_) {
//       notifyListeners(); // ✅ แจ้งให้ UI โหลดค่าล่าสุด
//     });
//   }

//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     _name = prefs.getString("name") ?? "";
//     _email = prefs.getString("email") ?? "";
//     _password = prefs.getString("password") ?? "";
//     _phoneNumber = prefs.getString("phoneNumber") ?? "0924387042";
//     notifyListeners();
//   }

//   Future<void> updateName(String newName) async {
//     _name = newName;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("name", newName);
//     notifyListeners();
//   }

//   Future<void> updateEmail(String newEmail) async {
//     _email = newEmail;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("email", newEmail);
//     notifyListeners();
//   }

//   Future<void> updatePassword(String newPassword) async {
//     _password = newPassword;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("password", newPassword);
//     notifyListeners();
//   }

//   Future<void> updatePhone(String newPhone) async {
//     _phoneNumber = newPhone;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("phoneNumber", newPhone);
//     notifyListeners();
//   }
// }

// // Settings Screen
// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   late TextEditingController nameController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController phoneController;

//   bool isEditingPhone = false;
//   bool showPassword = false; // ควบคุมการแสดงรหัสผ่าน

//   @override
//   void initState() {
//     super.initState();
//     final userProvider = Provider.of<SettingsProvider>(context, listen: false);
//     nameController = TextEditingController(text: userProvider.name);
//     emailController = TextEditingController(text: userProvider.email);
//     passwordController = TextEditingController(text: userProvider.password);
//     phoneController = TextEditingController(text: userProvider.phoneNumber);
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }

//   // ฟังก์ชันแสดง Dialog เพื่อยืนยันรหัสผ่านก่อนดู
//   Future<void> _showPasswordConfirmationDialog(
//       BuildContext context, SettingsProvider userProvider) async {
//     final confirmationController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("ยืนยันรหัสผ่าน"),
//           content: TextField(
//             controller: confirmationController,
//             obscureText: true,
//             decoration: const InputDecoration(
//               labelText: "กรุณาใส่รหัสผ่าน",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("ยกเลิก"),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (confirmationController.text == userProvider.password) {
//                   setState(() {
//                     showPassword = true; // แสดงรหัสผ่าน
//                   });
//                   Navigator.of(context).pop();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("รหัสผ่านไม่ถูกต้อง"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: const Text("ยืนยัน"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<SettingsProvider>(context);
//     return Scaffold(
//       appBar: AppBar(title: const Text("Settings")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Username Field (ดูได้อย่างเดียว)
//             TextField(
//               controller: nameController,
//               enabled: false, // ไม่สามารถแก้ไขได้
//               decoration: const InputDecoration(labelText: "ชื่อผู้ใช้"),
//             ),
//             const SizedBox(height: 10),

//             // Email Field (ดูได้อย่างเดียว)
//             TextField(
//               controller: emailController,
//               enabled: false, // ไม่สามารถแก้ไขได้
//               decoration: const InputDecoration(labelText: "อีเมล"),
//             ),
//             const SizedBox(height: 10),

//             // Password Field (สามารถกดดูรหัสผ่านได้ แต่ไม่สามารถแก้ไขได้)
//             TextField(
//               controller: passwordController,
//               enabled: false, // ไม่สามารถแก้ไขได้
//               obscureText: !showPassword, // ซ่อนหรือแสดงรหัสผ่าน
//               decoration: InputDecoration(
//                 labelText: "รหัสผ่าน",
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     showPassword ? Icons.visibility : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       showPassword = !showPassword; // สลับสถานะการแสดงรหัสผ่าน
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Phone Number Field (แก้ไขได้)
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: phoneController,
//                     enabled: isEditingPhone, // เปิดใช้งานเมื่ออยู่ในโหมดแก้ไข
//                     decoration:
//                         const InputDecoration(labelText: "PromptPay Number"),
//                     keyboardType: TextInputType.phone,
//                     onChanged: (value) => userProvider.updatePhone(value),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(isEditingPhone ? Icons.check : Icons.edit),
//                   onPressed: () {
//                     if (isEditingPhone) {
//                       userProvider.updatePhone(
//                           phoneController.text); // บันทึกหมายเลขโทรศัพท์ใหม่
//                     }
//                     setState(() {
//                       isEditingPhone = !isEditingPhone; // สลับโหมดแก้ไข
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // Removed unused import
// import 'package:shared_preferences/shared_preferences.dart';

// // Provider สำหรับเก็บข้อมูลผู้ใช้
// class SettingsProvider extends ChangeNotifier {
//   String _name = "";
//   String _email = "";
//   String _password = "";
//   String _phoneNumber = "0924387042";

//   String get name => _name;
//   String get email => _email;
//   String get password => _password;
//   String get phoneNumber => _phoneNumber;

//   void setUserData(String name, String email, String password) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("name", name);
//     await prefs.setString("email", email);
//     await prefs.setString("password", password);

//     _name = name; // ✅ ตั้งค่าตัวแปรใหม่ตรงนี้
//     _email = email;
//     _password = password;

//     notifyListeners(); // ✅ แจ้ง UI ให้อัปเดต
//   }

//   SettingsProvider() {
//     _loadData().then((_) {
//       notifyListeners(); // ✅ แจ้งให้ UI โหลดค่าล่าสุด
//     });
//   }

//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     _name = prefs.getString("name") ?? "";
//     _email = prefs.getString("email") ?? "";
//     _password = prefs.getString("password") ?? "";
//     _phoneNumber = prefs.getString("phoneNumber") ?? "0924387042";
//     notifyListeners();
//   }

//   Future<void> updateName(String newName) async {
//     _name = newName;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("name", newName);
//     notifyListeners();
//   }

//   Future<void> updateEmail(String newEmail) async {
//     _email = newEmail;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("email", newEmail);
//     notifyListeners();
//   }

//   Future<void> updatePassword(String newPassword) async {
//     _password = newPassword;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("password", newPassword);
//     notifyListeners();
//   }

//   Future<void> updatePhone(String newPhone) async {
//     _phoneNumber = newPhone;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("phoneNumber", newPhone);
//     notifyListeners();
//   }
// }

// // Settings Screen
// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   late TextEditingController nameController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController phoneController;

//   bool isEditingName = false;
//   bool isEditingEmail = false;
//   bool isEditingPassword = false;
//   bool isEditingPhone = false;
//   bool showPassword = false; // Variable to control password visibility

//   @override
//   void initState() {
//     super.initState();
//     final userProvider = Provider.of<SettingsProvider>(context, listen: false);
//     nameController = TextEditingController(text: userProvider.name);
//     emailController = TextEditingController(text: userProvider.email);
//     passwordController = TextEditingController(text: userProvider.password);
//     phoneController = TextEditingController(text: userProvider.phoneNumber);
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }

//   // ฟังก์ชันแสดง Dialog เพื่อยืนยันรหัสผ่าน
//   Future<void> _showPasswordConfirmationDialog(
//       BuildContext context, SettingsProvider userProvider) async {
//     final confirmationController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("ยืนยันรหัสผ่าน"),
//           content: TextField(
//             controller: confirmationController,
//             obscureText: true,
//             decoration: const InputDecoration(
//               labelText: "กรุณาใส่รหัสผ่าน",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("ยกเลิก"),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (confirmationController.text == userProvider.password) {
//                   setState(() {
//                     showPassword = true; // แสดงรหัสผ่าน
//                   });
//                   Navigator.of(context).pop();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("รหัสผ่านไม่ถูกต้อง"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: const Text("ยืนยัน"),
//             ),
//           ],
//         );
//       },
//     );
//   }
