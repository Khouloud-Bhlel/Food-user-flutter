import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// 
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartProducts = [];
  TextEditingController addressController = TextEditingController();
  double totalCartPrice = 0; // Ajoutez cette ligne pour déclarer totalCartPrice comme variable d'instance

  @override
  void initState() {
    super.initState();
    _getCartProducts();
  }

  void _getCartProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartProductsJson = prefs.getStringList('cart') ?? [];

    List<Map<String, dynamic>> products = [];
    for (String productJson in cartProductsJson) {
      try {
        Map<String, dynamic> productDetails = jsonDecode(productJson);
        products.add(productDetails);
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
    int quantity = product['quantity'];
    double price = product['price'] != null ? double.parse(product['price'].toString()) : 0;
    double unitPrice = quantity * price;
    print('Unit Price: \$${unitPrice.toStringAsFixed(2)}');
    return unitPrice;
  }

  void _confirmOrder() async {
  String address = addressController.text;
   

  if (address.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez entrer une adresse de livraison.')),
    );
    return;
  }

  

  
  if (cartProducts.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Votre panier est vide.')),
    );
    return;
  }

  // Declare the orderDetails variable here before using it
  Map<String, dynamic> orderDetails = {
    'adresse': address,
    'Products': [],
    'Total': 0,
  };

  List<Map<String, dynamic>> products = [];
  double totalCartPrice = 0;

  for (var product in cartProducts) {
    int quantity = product['quantity'] ?? 0;
    double price = product['price'] != null ? double.parse(product['price'].toString()) : 0;

    // Check if quantity and price are valid
    if (quantity <= 0 || price <= 0) {
      print('Invalid quantity or price for product: $product');
      continue; // Move to the next product if it's invalid
    }

    double totalPrice = quantity * price;
    totalCartPrice += totalPrice;

    Map<String, dynamic> productData = {
      'product': product['id'], // Use 'id' instead of 'product'
      'quantiteCommande': quantity,
      'PrixUnit': totalPrice,
    };
    products.add(productData);
  }

  if (totalCartPrice <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Le prix total du panier est invalide.')),
    );
    return;
  }

  orderDetails['Products'] = products;
  orderDetails['Total'] = totalCartPrice;

  print('Order Details: $orderDetails'); // Print order details

  try {
    final response = await http.post(
      Uri.parse('http://192.168.0.237:9000/api/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderDetails),
    );
    print('Server Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 201) {
      print('Order added successfully');
      _clearCart(); // Call to clear the cart after a successful order
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commande confirmée avec succès.')),
      );
    } else {
      print('Failed to add order: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la confirmation de la commande. Veuillez réessayer.')),
      );
    }
  } catch (e) {
    print('Error sending order: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la confirmation de la commande. Veuillez réessayer.')),
    );
  }
}







 void _clearCart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('cart');
  setState(() {
    cartProducts = []; // Mettre à jour l'état pour vider le panier
  });
}

 void _removeProduct(int index) async {
  setState(() {
    cartProducts.removeAt(index);
    _updateTotal();
  });

  // Mettre à jour la liste des produits dans les SharedPreferences après avoir supprimé un produit
  List<String> updatedCartProductsJson = cartProducts.map((product) => jsonEncode(product)).toList();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('cart', updatedCartProductsJson);
}

  void _updateTotal() {
    double newTotal = 0;
    cartProducts.forEach((product) {
      newTotal += calculateTotalPrice(product);
    });
    setState(() {
      totalCartPrice = newTotal;
    });
  }
  @override
  Widget build(BuildContext context) {
    double totalCartPrice = 0;
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
  Text('Quantité: ${product['quantity']}'),
  Text('Prix total: ${totalPrice.toStringAsFixed(2)} Dt'),
],
                  ),
trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeProduct(index),
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
  'Total du panier : ${totalCartPrice.toStringAsFixed(2)} Dt',
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
                        onPressed: _confirmOrder,
                        child: Text('Confirmer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addressController.clear();
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
