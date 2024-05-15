import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<dynamic> orders = []; // Liste pour stocker les commandes du client

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Appel de la méthode pour récupérer les commandes
  }

  // Méthode pour récupérer les commandes du client
Future<void> fetchOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String clientId = prefs.getString('clientId') ?? '';
  if (clientId.isEmpty) {
    // Gérer le cas où l'ID client n'est pas disponible
    return;
  }
  String url = 'http://192.168.218.223:9000/api/orders?clientId=$clientId';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        orders = jsonDecode(response.body);
      });
    } else {
      // Gérer les erreurs de récupération des commandes
      print('Failed to fetch orders: ${response.statusCode}');
    }
  } catch (e) {
    // Gérer les erreurs de connexion
    print('Error fetching orders: $e');
  }
}



  @override
  Widget build(BuildContext context) {
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
          "OrderPage",
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            // Construction de l'élément de la liste pour chaque commande
            return Card(
              // Utilisez la structure des données de la commande pour afficher les détails
              child: ListTile(
                title: Text('Order ${orders[index]["Numero"]}'), // Utilisez les détails de la commande appropriés
                subtitle: Text('Date: ${orders[index]["Date"]}'), // Utilisez les détails de la commande appropriés
                // Ajoutez d'autres détails de la commande si nécessaire
              ),
            );
          },
        ),
      ),
    );
  }
}
