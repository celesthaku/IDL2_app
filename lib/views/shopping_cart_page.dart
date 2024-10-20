import 'package:flutter/material.dart';
import '../view_models/cart_view_model.dart';

class ShoppingCartPage extends StatelessWidget {
  final CartViewModel cartViewModel;

  ShoppingCartPage({required this.cartViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de compras'),
      ),
      body: Column(
        children: [
          // Lista de productos en el carrito
          Expanded(
            child: ListView.builder(
              itemCount: cartViewModel.cartItems.length,
              itemBuilder: (context, index) {
                var product = cartViewModel.cartItems[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Text('S/ ${product.price * product.quantity}'),
                );
              },
            ),
          ),

          // Sección del total
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'S/ ${cartViewModel.getTotal().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
