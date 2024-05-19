import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DeliveryPage extends StatefulWidget {
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _transportTypeController = TextEditingController();
  File? _idCardImage;

  Future<void> _submitDelivery() async {
    final String apiUrl = 'http://192.168.0.237:9000/api/livreurs';

    final Map<String, dynamic> deliveryData = {
      'nom': _firstNameController.text,
      'prenom': _lastNameController.text,
      'ville': _cityController.text,
      'codePostal': _postalCodeController.text,
      'rue': _streetController.text,
      'email': _emailController.text,
      'tel': _phoneController.text, // Use string here
      'typedetransport': _transportTypeController.text,
      'copieCin': _idCardImage == null ? null : _idCardImage!.path,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(deliveryData),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Delivery Successful'),
            content: Text('The delivery person has been successfully added.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Close the delivery page
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
            title: Text('Delivery Failed'),
            content: Text('Failed to add delivery person. Please try again.'),
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
    } catch (error) {
      print('Error adding delivery person: $error');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while adding the delivery person. Please try again later.'),
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

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _idCardImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Delivery Person'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: _postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code'),
              ),
              TextField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Street'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _transportTypeController,
                decoration: InputDecoration(labelText: 'Transport Type'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select ID Card Image'),
              ),
              _idCardImage != null
                  ? Image.file(_idCardImage!)
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  if (_idCardImage != null) {
                    _submitDelivery();
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Image Not Selected'),
                        content: Text('Please select an ID card image.'),
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
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
