import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:resterant_app/screens/discount.dart';
import 'package:resterant_app/widgets/home_category.dart';
import 'package:resterant_app/widgets/grid_product.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> _categoriesFuture;
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
     _productsFuture = fetchProducts();

  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('http://192.168.31.223:9000/api/categories'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }
   Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://192.168.31.223:9000/api/products'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Discounts",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                MaterialButton(
                  child: Text(
                    "View More",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DiscountPage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              " Categories",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),
            FutureBuilder<List<dynamic>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> categories = snapshot.data ?? [];
                  return Container(
                    height: 65.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map category = categories[index];
                        return HomeCategory(
                          imageUrl: category['image'], // Remplacez 'image' par la clé appropriée pour l'image dans votre API
                          name: category['name'], // Remplacez 'name' par la clé appropriée pour le nom dans votre API
                          isHome: true,
                          tap: () {
                            // Vous pouvez ajouter la fonctionnalité pour le tap ici.
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
             SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Produits ",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                MaterialButton(
                  child: Text(
                    "View More",
                    style: TextStyle(),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10.0),
          FutureBuilder<List<dynamic>>(
  future: _productsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      List<dynamic> products = snapshot.data ?? [];
      return GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.25),
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          Map? product = products[index];
          if (product != null) {

           return GridProduct(
  imageUrl: product['image'] ?? '',
  name: product['name'] ?? '',
  desc: product['desc'] ?? '',
  productId: product['_id'] ?? '',
  price: (product['price'] ?? 0).toDouble(), // Convertir le prix en double


);

          } else {
            return SizedBox();
          }
        },
      );
    }
  },
),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}