import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

Future<List<dynamic>> fetchPromotionalProducts() async {
  final response = await http.get(Uri.parse('http://192.168.0.237:9000/api/products'));
  if (response.statusCode == 200) {
    final List<dynamic> products = jsonDecode(response.body);
    final List<dynamic> promotionalProducts = products.where((product) =>
        product['promotion'] != null &&
        product['promotion'] != 0 &&
        product['promotion']['reduction'] != null).toList();
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

  @override
  void initState() {
    super.initState();
    _promotionalProductsFuture = fetchPromotionalProducts();
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
            return ListView.builder(
              itemCount: products?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
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
  'PricePromo: ${products?[index]['promotion']['PricePromo'] ?? ''} Dt',
  style: TextStyle(fontWeight: FontWeight.bold),
),

                            SizedBox(width: 8),
                            if (products?[index]['promotion'] != null)
                              Text(
  'Price: ${products?[index]['price'] ?? ''} Dt',
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
