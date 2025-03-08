import 'package:flutter/material.dart';
import 'package:project/pages/payment_screen.dart';
import '../model/menu_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // รายการเมนูทั้งหมด
  List<MenuItem> menuItems = [
    MenuItem(
      name: 'กาแฟดำ',
      price: 45,
      image: 'https://mpics.mgronline.com/pics/Images/563000011136201.JPEG',
    ),
    MenuItem(
      name: 'ลาเต้',
      price: 50,
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQog4pvn467fHusxUe22IwerOwxcveQXr8taA&s',
    ),
    MenuItem(
      name: 'ชาเขียว',
      price: 55,
      image:
          'https://imgs.search.brave.com/xKpv0QheuC2832rMozPVq0lCtwLdbZtefXhgrh-VuZI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZS5iYW5na29rYml6/bmV3cy5jb20vdXBs/b2Fkcy9pbWFnZXMv/Y29udGVudHMvdzEw/MjQvMjAyNS8wMS9H/QmZYSHRPd3hRU0dX/WE5ucHNDMi53ZWJw/P3gtaW1hZ2UtcHJv/Y2Vzcz1zdHlsZS9s/Zy13ZWJw',
    ),
    MenuItem(
      name: 'ชานมไข่มุก',
      price: 65,
      image:
          'https://imgs.search.brave.com/-EMw3vieWjkO18z96KI8TbF7dMgfYkSCxZsDh4kgoIk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/bWl0cnBob2xzdWdh/ci5jb20vd3AtY29u/dGVudC91cGxvYWRz/LzIwMjIvMDgvJUUw/JUI4JUEzJUUwJUI4/JUFBJUUwJUI4JThB/JUUwJUI4JUIyJUUw/JUI4JTk1JUUwJUI4/JUI0JUUwJUI5JTgx/JUUwJUI4JUE1JUUw/JUI4JUIwJUUwJUI4/JTgxJUUwJUI4JUIy/JUUwJUI4JUEzJUUw/JUI5JTgzJUUwJUI4/JThBJUUwJUI5JTg5/JUUwJUI4JUE3JUUw/JUI4JUIxJUUwJUI4/JTk1JUUwJUI4JTk2/JUUwJUI4JUI4JUUw/JUI4JTk0JUUwJUI4/JUI0JUUwJUI5JTgx/JUUwJUI4JUE1JUUw/JUI4JUI0JUUw/JUI4JUIyJUUw/JUI4JUIxJUUwJUI4/JUE2JUUwJUI5JTk5/JUUwJUI4JThBJUUwJUI4/JUFCJUUwJUI4JUI1/JUUwJUI5JTg4',
    ),
  ];

  List<MenuItem> selectedItems = [];

  void addItem(MenuItem item) {
    setState(() {
      selectedItems.add(item);
    });
  }

  void removeItem(int index) {
    setState(() {
      selectedItems.removeAt(index);
    });
  }

  int getTotalPrice() {
    return selectedItems.fold(
        0, (sum, item) => sum + item.price); // คำนวณราคาจากรายการ selectedItems
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () => addItem(menuItems[index]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              menuItems[index].image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(menuItems[index].name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('${menuItems[index].price} บาท',
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
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('รายการที่เลือก',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(selectedItems[index].image,
                              width: 40, height: 40, fit: BoxFit.cover),
                          title: Text(selectedItems[index].name),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => removeItem(index),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text('ราคารวม: ${getTotalPrice()} บาท',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _navigateToPaymentScreen,
                    child: Text('ชำระเงิน',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPaymentScreen() {
    // Get the total price of selected items
    int totalPrice = getTotalPrice(); // คำนวณราคาจาก selectedItems

    // Navigate to the payment screen and pass the totalPrice
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentQRCodeScreen(
            totalAmount: totalPrice.toDouble()), // ส่ง totalPrice
      ),
    );
  }
}
