// add_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:project/model/menu_item.dart';

class AddMenuScreen extends StatefulWidget {
  final Function(MenuItem) onAddMenu;

  AddMenuScreen({required this.onAddMenu});

  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  String? _imageUrl;
  bool _isImageValid = true;

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

    widget.onAddMenu(newMenuItem);
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
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'ชื่อเมนู'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ราคา'),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'URL รูปภาพ'),
              onChanged: _validateImageUrl,
            ),
            SizedBox(height: 20),
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
                    child: Center(child: Text('กรุณากรอก URL รูปภาพ')),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMenu,
              child: Text('บันทึกเมนู'),
            ),
          ],
        ),
      ),
    );
  }
}
