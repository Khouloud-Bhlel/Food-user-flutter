import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resterant_app/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  Future<void> loginUser(BuildContext context, String email, String password) async {
    String url = 'http://192.168.0.237:9000/api/login';

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return MainScreen();
          },
        ));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password'),
              actions: <Widget>[
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
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: <Widget>[
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
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 25.0),
              child: Text(
                "Log in to your account",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Implement Forgot Password functionality
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  loginUser(context, email, password);
                },
                child: Text(
                  "LOGIN".toUpperCase(),
                ),
              ),
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
