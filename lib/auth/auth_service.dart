import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:daniknews/homepage/homepage.dart';
import 'package:daniknews/auth/signup_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  isLoggedIn() {
    if (_auth.currentUser != null) {
      return const Homepage();
    } else {
      return SignUpPage();
    }
  }
}
