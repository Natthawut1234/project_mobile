import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/pages/payment_screen.dart';
import '../provider/list_menu.dart';
import '../model/menu_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final listMenu = Provider.of<ListMenu>(context);

    // กรองเมนูตามคำค้นหา
    final filteredMenu = listMenu.menuItems.where((item) {
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // 🔹 ช่องค้นหาเมนู
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ค้นหาเมนู...',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // อัปเดตค่าค้นหา
                });
              },
            ),
          ),

          Expanded(
            child: Row(
              children: [
                // 🔹 รายการเมนู (GridView)
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: filteredMenu.length, // ใช้เมนูที่ถูกกรอง
                    itemBuilder: (context, index) {
                      final item = filteredMenu[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () => listMenu.addItem(item),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  child: Image.network(
                                    item.image,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(item.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('${item.price} บาท',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔹 ตะกร้าสินค้า
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายการที่เลือก',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),

                        // ✅ ใช้ Consumer เพื่อให้ UI อัปเดตเมื่อ selectedItems เปลี่ยน
                        Expanded(
                          child: Consumer<ListMenu>(
                            builder: (context, listMenu, child) {
                              return ListView.builder(
                                itemCount: listMenu.selectedItems.length,
                                itemBuilder: (context, index) {
                                  final selectedItem =
                                      listMenu.selectedItems[index];

                                  return ListTile(
                                    leading: Image.network(
                                      selectedItem.image,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(selectedItem.name),
                                    subtitle:
                                        Text('ราคา: ${selectedItem.price} บาท'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove_circle,
                                          color: Colors.red),
                                      onPressed: () =>
                                          listMenu.removeItem(index),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        Divider(),

                        // ✅ แสดงจำนวนรายการที่เลือก
                        Text(
                            'รายการที่เลือก: ${listMenu.selectedItems.length} รายการ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),

                        // ✅ แสดงราคารวม
                        Consumer<ListMenu>(
                          builder: (context, listMenu, child) {
                            return Text(
                              'ราคารวม: ${listMenu.getTotalPrice()} บาท',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          },
                        ),

                        SizedBox(height: 10),

                        // ✅ ปุ่มชำระเงิน
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () => _navigateToPaymentScreen(context),
                          child: Text('ชำระเงิน',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ฟังก์ชันนำทางไปหน้าชำระเงิน
  void _navigateToPaymentScreen(BuildContext context) {
    final listMenu = Provider.of<ListMenu>(context, listen: false);
    int totalPrice = listMenu.getTotalPrice();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentQRCodeScreen(
            totalAmount: totalPrice.toDouble(),
            selectedItems: listMenu.selectedItems), // ✅ ส่งรายการที่เลือก
      ),
    );
  }
}
