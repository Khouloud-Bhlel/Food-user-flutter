import 'package:flutter/material.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Adresse',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    // Action lorsque le bouton "Passer commande" est pressé
                    String address = _addressController.text;
                    // Effectuer le traitement nécessaire ici
                  },
                  child: Text('Passer commande'),
                ),
                RaisedButton(
                  onPressed: () {
                    // Action lorsque le bouton "Annuler" est pressé
                    Navigator.pop(context); // Fermer la page de confirmation
                  },
                  child: Text('Annuler'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}