import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:resterant_app/screens/main_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameControl = TextEditingController();
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final TextEditingController _confirmPasswordControl = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
        final String accessToken = googleAuth?.accessToken ?? '';

        // Now you can send the accessToken to your backend for verification and user creation if necessary

        // Navigate to your main screen after successful login
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return MainScreen();
          },
        ));
      } else {
        // Handle null case
        print('Google sign-in failed');
      }
    } catch (error) {
      print('Google sign-in error: $error');
      // Handle sign-in errors here
    }
  }
  Future<void> registerUser(BuildContext context) async {
    final String apiUrl = 'http://192.168.0.237:9000/api/register_flutter';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'fullName': _fullNameControl.text,
          'email': _emailControl.text,
          'password': _passwordControl.text,
          'confirmPassword': _confirmPasswordControl.text,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // Registration successful, navigate to the main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MainScreen();
            },
          ),
        );
      } else {
        // Registration failed, display an error message
        final Map<String, dynamic> responseData = json.decode(response.body);
        final errorMessage = responseData['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error during registration: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred during registration.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Register"),
      // ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 25.0),
              child: Text(
                "Create new account",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: _fullNameControl,
              decoration: InputDecoration(
                hintText: "Full Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _emailControl,
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordControl,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _confirmPasswordControl,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => registerUser(context),
              child: Text("Register"),
            ),
            SizedBox(height: 10.0),
            Divider(),
             SizedBox(height: 10.0),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        _handleGoogleSignIn(context);  
                     },
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
