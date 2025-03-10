// menu_item.dart

class MenuItem {
  final String name;
  final int price;
  final String image;

  static var length;

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
  });

  // Method to convert a MenuItem to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
    };
  }

  // Factory method to create a MenuItem from a map
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }
}
