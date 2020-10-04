import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();
  static get shared => _instance;

  final InitialSettingModel _initialSetting = InitialSettingModel();
  InitialSettingModel get initialSetting => _initialSetting;

  User get user {
    assert(_user != null,
        "you should call fetch and caching user before call this property. ");
    if (_user == null) throw UserNotFound();
    return _user;
  }

  User _user;

  static AppState watch(BuildContext context) {
    return context.watch();
  }

  static AppState read(BuildContext context) {
    return context.read();
  }

  Future<AppState> notifyWith(void update(AppState model)) {
    update(this);
    notifyListeners();
    return Future.value(this);
  }
}

extension UserInterface on AppState {
  static Future<User> fetchOrCreateUser() {
    return UserInterface._fetch().catchError((error) {
      if (error is UserNotFound) {
        return UserInterface._create().then((_) => UserInterface._fetch());
      }
      throw FormatException(
          "cause exception when failed fetch and create user for $error");
    });
  }

  static Future<void> _create() {
    assert(AppState.shared._user == null,
        "user already exists on process. maybe you will call fetch before create");
    if (AppState.shared._user != null) throw UserAlreadyExists();
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(auth.FirebaseAuth.instance.currentUser.uid)
        .set(
      {
        UserFirestoreFieldKeys.anonymouseUserID:
            auth.FirebaseAuth.instance.currentUser.uid,
      },
    );
  }

  static Future<User> _fetch() {
    if (AppState.shared._user != null) {
      return Future.value(AppState.shared._user);
    }

    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(auth.FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      var user = User.map(document.data());
      assert(AppState.shared._user == null,
          "you should early return cached user. e.g) this function top level");
      AppState.shared._user = user;
      return user;
    });
  }
}
