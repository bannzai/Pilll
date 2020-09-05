import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:Pilll/model/user.dart' as immutableUser;

class AuthUser extends ChangeNotifier {
  UserCredential _userCredential;
  UserCredential get userCredential => _userCredential;
  set userCredential(UserCredential value) {
    _userCredential = value;
    notifyListeners();
  }

  immutableUser.User _user;
  immutableUser.User get user => _user;
  set user(immutableUser.User value) {
    _user = value;
    notifyListeners();
  }
}
