import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:resterant_app/screens/myorder.dart';
import 'package:resterant_app/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  ProductDetails({required this.productId});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? _productDetails;
    int _quantity = 1; // Initial value for quantity


  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  void _fetchProductDetails() async {
  try {
final response = await http.get(Uri.parse('http://192.168.0.237:9000/api/products/${widget.productId}'));
    if (response.statusCode == 200) {
      setState(() {
        _productDetails = jsonDecode(response.body);
        // Ajouter le prix du produit aux détails du produit
        _productDetails?['price'] = _productDetails?['price']; // Assurez-vous que la clé 'price' existe dans les détails du produit
      });
    } else {
      throw Exception('Failed to load product details');
    }
  } catch (e) {
    print('Error: $e');
  }
}


void _addToCart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cartProducts = prefs.getStringList('cart') ?? [];
  
  // Add product details to cart
  Map<String, dynamic> productDetails = {
    'id': widget.productId,
    'name': _productDetails?['name'] ?? '',
    'image': _productDetails?['image'] ?? '',
    'price': _productDetails != null && _productDetails!['price'] != null ? _productDetails!['price'].toString() : '0', // Vérifiez d'abord si _productDetails est null avant d'accéder à sa propriété price
    'quantity': _quantity,
  };
  cartProducts.add(jsonEncode(productDetails)); // Convert product details to JSON
  
  await prefs.setStringList('cart', cartProducts);
  print('Product Details Added to Cart: $productDetails');
}




void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Method to decrement quantity
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
  


  @override
  Widget build(BuildContext context) {
    if (_productDetails != null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Item Details",
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_bag,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return OrderPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Stack(
                children: <Widget>[
                  Container(
  height: MediaQuery.of(context).size.height / 3.2,
  width: MediaQuery.of(context).size.width,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.network(
      _productDetails?['image'] ?? '', // Use null-aware operators
      fit: BoxFit.cover,
    ),
  ),
),

               if (_productDetails != null &&
                _productDetails!['promotion'] != null &&
                _productDetails!['promotion']['reduction'] != null)
              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: () {},
                  fillColor: Colors.red, // Couleur du cercle pour une réduction existante
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Center(
  child: Text(
    '${_productDetails!['promotion']['reduction']}%', // Affichage de la valeur de réduction avec le symbole de pourcentage
    style: TextStyle(
      color: Colors.white, // Couleur du texte
      fontSize: 12.0, // Taille du texte
    ),
  ),
),

                ),
              ),
          ],
        ),
        SizedBox(height: 10.0),
              Text(
_productDetails?['name'] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10.0),
             
Text(
  'Prix: ${(_productDetails?['price'] ?? 0).toStringAsFixed(2)} DT',
  style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w300,
  ),
),




              SizedBox(height: 20.0),
              Text(
                "Product Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10.0),
              Text(
_productDetails?['desc'] ?? '',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              
              SizedBox(height: 10.0),
               Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Quantity:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decrementQuantity,
                    ),
                    Text(
                      _quantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          child: ElevatedButton(
            child: Text(
              "ADD TO CART",
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            onPressed: () {
              _addToCart();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added to cart')));
            },
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}