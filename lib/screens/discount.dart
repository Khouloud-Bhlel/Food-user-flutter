
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

Future<List<dynamic>> fetchPromotionalProducts() async {
  final response = await http.get(Uri.parse('http://192.168.31.223:9000/api/products'));
  if (response.statusCode == 200) {
    final List<dynamic> products = jsonDecode(response.body);
    // Filtrer les produits pour ne récupérer que ceux en promotion
    final List<dynamic> promotionalProducts = products.where((product) => product['promotion'] != null && product['promotion'] != 0 && product['promotion']['reduction'] != null).toList();
    return promotionalProducts;
  } else {
    throw Exception('Failed to load promotional products');
  }
}

class DiscountPage extends StatefulWidget {
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  late Future<List<dynamic>> _promotionalProductsFuture;
  late int _currentIndex = 0; // Indice du produit actuellement affiché

  @override
  void initState() {
    super.initState();
    _promotionalProductsFuture = fetchPromotionalProducts();
    // Démarrer le minuteur pour changer de produit toutes les 2 secondes
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3; // Suppose qu'il y a 3 produits dans la liste (modifier selon votre cas)
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _promotionalProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<dynamic>? products = snapshot.data;
            return PageView.builder(
              itemCount: products?.length ?? 0,
              controller: PageController(
                initialPage: _currentIndex,
              ),
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: index == _currentIndex ? 1.0 : 0.0, // Afficher seulement le produit actuel
                  duration: Duration(milliseconds: 500),
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          products?[index]['image'] ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                'PricePromo: \$${products?[index]['promotion']['PricePromo'] ?? ''}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              if (products?[index]['promotion'] != null)
                                Text(
                                  'Price: \$${products?[index]['price'] ?? ''}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products?[index]['name'] ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                products?[index]['desc'] ?? '',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${products?[index]['promotion']['reduction'] ?? ''}%',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
