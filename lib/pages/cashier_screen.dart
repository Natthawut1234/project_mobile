import 'package:flutter/material.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  List<Map<String, dynamic>> cart = [];

  void addToCart(String productName, double price) {
    setState(() {
      int index = cart.indexWhere((item) => item['name'] == productName);
      if (index != -1) {
        cart[index]['quantity']++;
      } else {
        cart.add({'name': productName, 'price': price, 'quantity': 1});
      }
    });
  }

  void updateQuantity(int index, int change) {
    setState(() {
      cart[index]['quantity'] += change;
      if (cart[index]['quantity'] <= 0) {
        cart.removeAt(index);
      }
    });
  }

  double getTotalPrice() {
    return cart.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS แคชเชียร์'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // แสดงรายการสินค้าที่เพิ่มเข้าตะกร้า
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('ยังไม่มีสินค้าในตะกร้า'))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(cart[index]['name']),
                          subtitle: Text(
                              "฿${cart[index]['price'].toStringAsFixed(2)} x ${cart[index]['quantity']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => updateQuantity(index, -1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => updateQuantity(index, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // สรุปยอดและปุ่มชำระเงิน
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text(
                  "ยอดรวม: ฿${getTotalPrice().toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (cart.isNotEmpty) {
                      // ไปหน้าชำระเงิน
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("ชำระเงิน",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addToCart("กาแฟเย็น", 50.0);
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("หน้าชำระเงิน")),
      body: const Center(child: Text("QR Code / เงินสด / บัตรเครดิต")),
    );
  }
}
