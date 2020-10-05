import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier  {
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
