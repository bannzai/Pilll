import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthUser extends ChangeNotifier {
  UserCredential _userCredential;
  UserCredential get userCredential => _userCredential;
  set userCredential(UserCredential value) {
    _userCredential = userCredential;
    notifyListeners();
  }
}
