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
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $itemName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                menuProvider.deleteItem(index); // ลบเมนูผ่าน Provider
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Menu')),
      body: Consumer<ListMenu>(
        builder: (context, menuProvider, child) {
          return ListView.builder(
            itemCount: menuProvider.menuItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(menuProvider.menuItems[index].name),
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
