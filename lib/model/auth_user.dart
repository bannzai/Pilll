import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:Pilll/model/user.dart' as pilllUser;

class AuthUser extends ChangeNotifier {
  UserCredential _userCredential;
  UserCredential get userCredential => _userCredential;
  set userCredential(UserCredential value) {
    _userCredential = value;
    notifyListeners();
  }

  pilllUser.User _user;
  pilllUser.User get user => _user;
  set user(pilllUser.User value) {
    _user = value;
    notifyListeners();
  }
}
