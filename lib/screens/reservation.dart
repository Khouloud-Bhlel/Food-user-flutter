import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _numPeopleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _submitReservation() async {
    final String apiUrl = 'http://192.168.0.237:9000/api/reservations';

    final List<String> dateParts = _dateController.text.split('/');
    final int? day = int.tryParse(dateParts[0]);
    final int? month = int.tryParse(dateParts[1]);
    final int? year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Invalid Date Format'),
          content: Text('Please enter the date in dd/mm/yyyy format.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final Map<String, dynamic> reservationData = {
      'nom': _nameController.text,
      'prenom': _lastNameController.text,
      'tel': int.parse(_phoneController.text),
      'Nombrepersonne': int.parse(_numPeopleController.text),
      'dateReservation': DateTime(year, month, day).toIso8601String(),
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservationData),
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Reservation Successful'),
          content: Text('Your reservation has been successfully created.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the reservation page
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Reservation Failed'),
          content: Text('Failed to create reservation. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Reservation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _numPeopleController,
                decoration: InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Reservation Date (dd/mm/yyyy)'),
              ),
              ElevatedButton(
                onPressed: _submitReservation,
                child: Text('Submit Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
