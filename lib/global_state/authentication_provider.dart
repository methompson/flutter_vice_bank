import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationProvider extends ChangeNotifier {
  User? _authenticatedUser;

  bool get isAuthenticated => _authenticatedUser != null;

  void setAuthentication(User? user) {
    _authenticatedUser = user;
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _authenticatedUser = null;

    notifyListeners();
  }

  Future<void> logUserIn(
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = FirebaseAuth.instance.currentUser;
    _authenticatedUser = user;

    notifyListeners();
  }
}
