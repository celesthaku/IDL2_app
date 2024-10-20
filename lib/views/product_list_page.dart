import 'package:flutter/material.dart';
import 'shopping_cart_page.dart';
import '../view_models/product_view_model.dart';
import '../view_models/cart_view_model.dart';
import '../models/product_model.dart';

class ProductListPage extends StatefulWidget {
  final CartViewModel cartViewModel = CartViewModel();  // Se gestiona el carrito de compras

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductViewModel viewModel = ProductViewModel();

  @override
  void initState() {
    super.initState();
    // Cargar productos
    viewModel.fetchProducts().then((_) {
      setState(() {});  // Actualiza la UI cuando los productos estén listos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bodega Digital'),
      ),
      body: viewModel.productList.isEmpty
          ? Center(child: CircularProgressIndicator())  // Mostrar un indicador de carga
          : Column(
              children: [
                // Sección de lista de productos
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.productList.length,
                    itemBuilder: (context, index) {
                      Product product = viewModel.productList[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(product.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (product.quantity > 0) product.quantity--;
                                });
                              },
                            ),
                            Text('${product.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  product.quantity++;
                                  widget.cartViewModel.addToCart(product);  // Agregar al carrito
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Botón para navegar al carrito
                Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Navegar a la pantalla del carrito
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingCartPage(cartViewModel: widget.cartViewModel),
                        ),
                      );
                    },
                    child: Text('Ir al carrito de compras'),
                  ),
                ),
              ],
            ),
    );
  }
}
