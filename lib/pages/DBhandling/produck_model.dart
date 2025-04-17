class Product {
  final int? id;
  final String name;
  final int qty;
  final int price;
  final String barcode;

  Product({
    this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'price': price,
      'barcode': barcode,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      qty: map['qty'],
      price: map['price'],
      barcode: map['barcode'],
    );
  }
}
