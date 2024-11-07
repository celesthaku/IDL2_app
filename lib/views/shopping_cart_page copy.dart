import 'package:flutter/material.dart';
import '../view_models/cart_view_model.dart';

class ShoppingCartPage extends StatelessWidget {
  final CartViewModel cartViewModel;

  ShoppingCartPage({required this.cartViewModel});

  // Controladores para los campos de entrada
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String selectedPaymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de compras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    trailing: Text(
                      'S/ ${ (product.price * product.quantity).toStringAsFixed(2) }',
                    ),
                  );
                },
              ),
            ),

            // Sección del total
            Row(
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
            SizedBox(height: 16),

            // Formulario de datos de compra
            Text(
              'Datos de compra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Selector de método de pago
            DropdownButtonFormField<String>(
              value: selectedPaymentMethod,
              items: [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'credit-card', child: Text('Credit Card')),
                DropdownMenuItem(value: 'debit-card', child: Text('Debit Card')),
              ],
              onChanged: (value) {
                selectedPaymentMethod = value!;
              },
              decoration: InputDecoration(labelText: 'Método de pago'),
            ),
            SizedBox(height: 10),

            // Campo de nombre
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 10),

            // Campo de teléfono
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),

            // Botón de obtener dirección (simulado)
            TextButton.icon(
              onPressed: () {
                // Aquí podrías integrar funcionalidad para obtener la geolocalización
                addressController.text = 'Dirección simulada';
              },
              icon: Icon(Icons.location_on),
              label: Text('Obtener mi dirección'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Dirección'),
              readOnly: true,
            ),
            SizedBox(height: 16),

            // Botón de compra
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí podrías agregar la funcionalidad para realizar la compra
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Compra realizada con éxito'),
                    ),
                  );
                },
                child: Text('Comprar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
