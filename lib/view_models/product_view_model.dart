import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductViewModel {
  List<Product> productList = [];
  int currentPage = 1;

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://shop-api-roan.vercel.app/product?page=$currentPage'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      for (var item in data) {
        productList.add(Product.fromJson(item));
      }
      currentPage++;
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  void addToCart(Product product, int count) {
    try {
      product.addToCart(count);
    } catch (e) {
      print(e); // Manejar la excepción y mostrar el error en la UI
    }
  }
}
