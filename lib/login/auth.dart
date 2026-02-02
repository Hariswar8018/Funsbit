import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  AuthService() {
    _auth.authStateChanges().listen((_) {
      notifyListeners(); // 🔥 triggers GoRouter redirect
    });
  }

  bool get isLoggedIn => _auth.currentUser != null;

  String? get uid => _auth.currentUser?.uid;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
