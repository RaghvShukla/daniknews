import 'package:flutter/material.dart';
import 'package:daniknews/services/style.dart';
import '../services/firebase_api.dart';
import 'select_category_page.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController name = TextEditingController();
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
              buildSignUp()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUp() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
              controller: name,
              keyboardType: TextInputType.text,
              decoration:
                  textFieldDecoration(const Icon(Icons.person), "Name")),
          const SizedBox(height: 20),
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
              onPressed: () async {
                if (name.text.isNotEmpty &&
                    email.text.isNotEmpty &&
                    password.text.isNotEmpty) {
                  await FirebaseApi().signUp(name.text, email.text, password.text);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCategories()),
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
                      )));
                }
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
              ),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already have an account?",
                  style: TextStyle(fontSize: 16)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                  child: const Text("Sign In", style: TextStyle(fontSize: 18)),
                  //textColor: Colors.purple.shade900,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
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
