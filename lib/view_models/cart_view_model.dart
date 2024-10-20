import '../models/product_model.dart';

class CartViewModel {
  List<Product> cartItems = [];

  // Agregar producto al carrito
  void addToCart(Product product) {
    if (!cartItems.contains(product)) {
      cartItems.add(product);
    }
  }

  // Calcular total
  double getTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
