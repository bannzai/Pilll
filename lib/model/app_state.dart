import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState shared = AppState._internal();
  factory AppState() => shared;
  AppState._internal();

  Future<void> subscribe() {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(user.documentID)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      print(event.data());
    }).asFuture();
  }

  final InitialSettingModel _initialSetting = InitialSettingModel();
  InitialSettingModel get initialSetting => _initialSetting;

  User _user;
  User get user {
    assert(_user != null,
        "you should call fetch and caching user before call this property. ");
    if (_user == null) throw UserNotFound();
    return _user;
  }

  set user(User user) {
    _user = user;
  }

  bool get userIsExists => _user != null;

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
