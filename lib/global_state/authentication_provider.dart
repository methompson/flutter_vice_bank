import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationProvider extends ChangeNotifier {
  User? _authentication;

  bool get isAuthenticated => _authentication != null;

  void setAuthentication(User? user) {
    _authentication = user;
    notifyListeners();
  }
}
