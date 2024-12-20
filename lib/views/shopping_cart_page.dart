import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../view_models/cart_view_model.dart';

class ShoppingCartPage extends StatefulWidget {
  final CartViewModel cartViewModel;

  ShoppingCartPage({required this.cartViewModel});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  // Controladores para los campos de entrada
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String selectedPaymentMethod = 'cash';
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // El servicio de ubicación no está habilitado, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, habilite los servicios de ubicación')),
      );
      return;
    }

    // Verificar los permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, muestra un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados permanentemente, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de ubicación denegado permanentemente')),
      );
      return;
    }

    // Si llegamos aquí, tenemos permisos y los servicios están habilitados
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      addressController.text = 'Latitud: ${position.latitude}, Longitud: ${position.longitude}';
    });
  }

  // Función para tomar una foto
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final imageBytes = await imageFile.readAsBytes();
      final imageSize = imageBytes.lengthInBytes / (1024 * 1024); // Tamaño en MB

      if (imageSize <= 1) {
        setState(() {
          _selectedImage = imageFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La imagen supera el tamaño máximo de 1MB')),
        );
      }
    }
  }

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
                itemCount: widget.cartViewModel.cartItems.length,
                itemBuilder: (context, index) {
                  var product = widget.cartViewModel.cartItems[index];
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
                  'S/ ${widget.cartViewModel.getTotal().toStringAsFixed(2)}',
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
                setState(() {
                  selectedPaymentMethod = value!;
                });
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

            // Botón de obtener dirección con geolocalización
            TextButton.icon(
              onPressed: () async {
                await _getCurrentLocation();
              },
              icon: Icon(Icons.location_on),
              label: Text('Obtener mi dirección'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Dirección'),
              readOnly: true,
            ),
            SizedBox(height: 10),

            // Botón para tomar una foto y mostrar la imagen seleccionada
            TextButton.icon(
              onPressed: () async {
                await _pickImage();
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Foto de la fachada'),
            ),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
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
