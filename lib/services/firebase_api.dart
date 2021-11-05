import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../auth/login_page.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class FirebaseApi {
  Future<User?> signUp(String name, String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = (credential).user;

      if (user != null) {
        user.updateDisplayName(name);
        await firestore.collection('users').doc(auth.currentUser?.uid).set({
          'name': name,
          'email': email,
        });
        return user;
      } else {
        return user;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      User? user = (await auth.signInWithEmailAndPassword(email: email, password: password)).user;

      if (user != null) {
        firestore.collection('users').doc(auth.currentUser?.uid).get().then((value) => user.displayName!);
        return user;
      } else {
        return user;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }

  Future logOut(BuildContext context) async {
    await auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }
}
