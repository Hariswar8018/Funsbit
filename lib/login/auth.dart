import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {

  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  bool get isLoggedIn => user != null;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
