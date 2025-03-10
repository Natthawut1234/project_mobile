import 'package:flutter/foundation.dart';
import 'package:project/model/menu_item.dart';

class ListMenu with ChangeNotifier {
  final List<MenuItem> _menuItems = [
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
          'https://cdn.pixabay.com/photo/2018/07/18/07/56/drink-3545791_1280.jpg',
    ),
  ];

  final List<MenuItem> _selectedItems = [];

  // ✅ Getter สำหรับเมนูทั้งหมด
  List<MenuItem> get menuItems => _menuItems;

  // ✅ Getter สำหรับเมนูที่ถูกเลือก
  List<MenuItem> get selectedItems => _selectedItems;

  // ✅ เพิ่มเมนูลงในตะกร้า
  void addItem(MenuItem item) {
    _selectedItems.add(item);
    notifyListeners(); // แจ้งให้ UI อัปเดต
  }

  // ✅ ลบเมนูจากตะกร้า
  void removeItem(int index) {
    _selectedItems.removeAt(index);
    notifyListeners(); // แจ้งให้ UI อัปเดต
  }

  // ✅ คำนวณราคารวม
  int getTotalPrice() {
    return _selectedItems.fold(0, (sum, item) => sum + item.price);
  }

  void deleteItem(int index) {
    menuItems.removeAt(index);
    notifyListeners(); // แจ้ง UI ให้รีเฟรช
  }

  void addMenuItem(MenuItem newMenuItem) {
    menuItems.add(newMenuItem);
    notifyListeners(); // แจ้งเตือน UI ให้รีเฟรช
  }

  // ✅ ฟังก์ชันเคลียร์ตะกร้าหลังชำระเงิน
  void clearCart() {
    _selectedItems.clear();
    notifyListeners(); // แจ้งให้ UI อัปเดต
  }
}
