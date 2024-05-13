import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartProducts = [];
  TextEditingController addressController = TextEditingController(); // Déclaration de addressController

  @override
  void initState() {
    super.initState();
    _getCartProducts();
  }

  void _getCartProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartProductsJson = prefs.getStringList('cart') ?? [];

    // Convert JSON strings back to Map
    List<Map<String, dynamic>> products = [];
    for (String productJson in cartProductsJson) {
      try {
        Map<String, dynamic> productDetails = jsonDecode(productJson);
        products.add(productDetails);
        
        // Déplacer cette instruction à l'intérieur de la boucle
        print('Product Details Retrieved from Cart: $productDetails');
      } catch (e) {
        print('Error decoding product JSON: $e');
      }
    }

    setState(() {
      cartProducts = products;
    });
  }


  double calculateTotalPrice(Map<String, dynamic> product) {
    int quantity = product['quantity']; // La quantité est un int
    double price = product['price'] != null ? double.parse(product['price'].toString()) : 0; // Le prix est un double
    double unitPrice = quantity * price; // Effectuez le calcul du prix unitaire
    print('Unit Price: \$${unitPrice.toStringAsFixed(2)}'); // Affichez le prix unitaire pour le débogage
    return unitPrice;
  }

  @override
  Widget build(BuildContext context) {
    double totalCartPrice = 0;
    // Calculer la somme de tous les prix unitaires
    cartProducts.forEach((product) {
      totalCartPrice += calculateTotalPrice(product);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> product = cartProducts[index];
                double totalPrice = calculateTotalPrice(product);
                return ListTile(
                  leading: Image.network(
                    product['image'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${product['quantity']}'),
                      Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Cart Price: \$${totalCartPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Action lorsque le bouton Confirmer est pressé
                          // Vous pouvez utiliser addressController.text pour obtenir l'adresse saisie
                        },
                        child: Text('Confirmer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Action lorsque le bouton Annuler est pressé
                          addressController.clear(); // Efface le texte de l'adresse
                        },
                        child: Text('Annuler'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
