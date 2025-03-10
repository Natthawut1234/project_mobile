import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:project/model/menu_item.dart';
import 'package:project/provider/list_menu.dart';

class AddMenuScreen extends StatefulWidget {
  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  String? _imageUrl;
  bool _isImageValid = true;

  // ฟังก์ชั่นเช็คความถูกต้องของข้อมูล
  final formKey = GlobalKey<FormState>();

  void _saveMenu() {
    final name = _nameController.text;
    final price = int.tryParse(_priceController.text) ?? 0;
    final image = _imageController.text;

    if (name.isEmpty || price <= 0 || image.isEmpty) {
      return;
    }

    final newMenuItem = MenuItem(
      name: name,
      price: price,
      image: image,
    );

    // ✅ ใช้ Provider แทน Callback
    Provider.of<ListMenu>(context, listen: false).addMenuItem(newMenuItem);

    Navigator.pop(context);
  }

  // ฟังก์ชั่นเช็ค URL รูปภาพ
  void _validateImageUrl(String url) {
    setState(() {
      _imageUrl = url;
      _isImageValid = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเมนูใหม่'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'ชื่อเมนู'),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อเมนู';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ราคา'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกราคา';
                }
                if (int.tryParse(value) == null) {
                  return 'กรุณากรอกตัวเลขเท่านั้น';
                }
                if (int.tryParse(value)! <= 0) {
                  return 'กรุณากรอกราคามากกว่า 0';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'URL รูปภาพ'),
              onChanged: _validateImageUrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอก URL รูปภาพ';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // ช่องแสดงตัวอย่างรูปภาพ
            _imageUrl != null && _isImageValid
                ? Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('ไม่สามารถโหลดภาพได้'));
                        },
                      ),
                    ),
                  )
                : Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(child: Text('กรุณากรอก URL รูปภาพ')),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ถ้าข้อมูลถูกต้อง
                if (formKey.currentState!.validate()) {
                  _saveMenu();
                }
              },
              child: const Text('บันทึกเมนู'),
            ),
          ]),
        ),
      ),
    );
  }
}
