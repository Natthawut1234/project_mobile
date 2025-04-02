import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/provider/list_menu.dart';

class DeleteMenuPage extends StatefulWidget {
  @override
  _DeleteMenuPageState createState() => _DeleteMenuPageState();
}

class _DeleteMenuPageState extends State<DeleteMenuPage> {
  void _confirmDelete(BuildContext context, int index) {
    final menuProvider = Provider.of<ListMenu>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        final itemName = menuProvider.menuItems[index].name;
        //รูปภาพเมนู
        final itemImage = menuProvider.menuItems[index].image;
        // แสดง AlertDialog เพื่อยืนยันการลบเมนู
        return AlertDialog(
          title: const Text('ยืนยันการลบเมนู'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // แสดงรูปภาพเมนูที่ต้องการลบ
              Image.network(itemImage, height: 100, width: 100),
              const SizedBox(height: 10),
              Text('คุณแน่ใจว่าต้องการลบ $itemName หรือไม่?'),
            ],
          ),
          // content: Text('คุณแน่ใจว่าต้องการลบ $itemName หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                menuProvider.deleteItem(index); // ลบเมนูผ่าน Provider
                Navigator.of(context).pop();
              },
              child: const Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลบเมนู')),
      body: Consumer<ListMenu>(
        builder: (context, menuProvider, child) {
          return ListView.builder(
            itemCount: menuProvider.menuItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(menuProvider.menuItems[index].name),
                //รูปภาพเมนู
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(menuProvider.menuItems[index].image),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
