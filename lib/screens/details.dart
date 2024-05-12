import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:resterant_app/screens/notifications.dart';
import 'package:resterant_app/util/const.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  ProductDetails({required this.productId});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? _productDetails;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  void _fetchProductDetails() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.33:9000/api/products/${widget.productId}'));
      if (response.statusCode == 200) {
        setState(() {
          _productDetails = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Error: $e');
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
                Icons.notifications,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Notifications();
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

                  Positioned(
                    right: -10.0,
                    bottom: 3.0,
                    child: RawMaterialButton(
                      onPressed: () {},
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      elevation: 4.0,
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
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          child: ElevatedButton(
            child: Text(
              "ADD TO CART",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {},
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
