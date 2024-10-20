class Product {
  final String id;
  final String slug;
  final String name;
  final String description;
  final double price;
  final int stock;
  int quantity;

  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.quantity = 0,
  });

  // Método para convertir los datos JSON a un objeto de tipo Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      // Convertimos el precio a double, manejando tanto int como double
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'],
      stock: json['stock'],
    );
  }

  void addToCart(int count) {
    if (quantity + count > stock) {
      throw Exception('No hay suficiente stock disponible');
    }
    quantity += count;
  }
}
