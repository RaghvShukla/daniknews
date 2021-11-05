import 'package:daniknews/auth/select_category_page.dart';
import 'package:flutter/material.dart';
import 'package:daniknews/services/style.dart';
import 'package:daniknews/auth/signup_page.dart';
import '../homepage/homepage.dart';
import '../services/firebase_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  "assets/logo.png",
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 16.0),
              Align(alignment: Alignment.bottomCenter, child: buildLogin())
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogin() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  textFieldDecoration(const Icon(Icons.email), "Email")),
          const SizedBox(height: 20),
          TextFormField(
              controller: password,
              obscureText: true,
              decoration:
                  textFieldDecoration(const Icon(Icons.lock), "Password")),
          const SizedBox(height: 20),
          Container(
            height: 80,
            width: 200,
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                if (email.text.isNotEmpty && password.text.isNotEmpty) {
                  FirebaseApi().signIn(email.text, password.text);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                      (Route<dynamic> route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.lightBlueAccent,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('oops login failed'),
                        ],
                      ),),);
                }
              },
              style: ElevatedButton.styleFrom(onPrimary: Colors.white),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          const Text("OR", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  FirebaseApi().signInWithGoogle();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCategories()),
                      (Route<dynamic> route) => false);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  child: Image.asset(
                    "assets/google.png",
                  ),
                ),
              ),
              const SizedBox(width: 30),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                child: Image.asset(
                  "assets/facebook.png",
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                  child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
