import 'package:flutter/cupertino.dart';
import 'package:Pilll/model/user.dart' as pilllUser;

class AuthUser extends ChangeNotifier {
  pilllUser.User _user;
  pilllUser.User get user => _user;
  set user(pilllUser.User value) {
    _user = value;
    notifyListeners();
  }
}
