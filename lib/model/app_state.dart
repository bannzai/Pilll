import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/repository/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState shared = AppState._internal();
  factory AppState() => shared;
  AppState._internal();

  final InitialSettingModel _initialSetting = InitialSettingModel();
  InitialSettingModel get initialSetting => _initialSetting;

  User _user;
  User get user {
    assert(_user != null,
        "you should call fetch and caching user before call this property. ");
    if (_user == null) throw UserNotFound();
    return _user;
  }

  set user(User user) => _user = user;
  bool get userIsExists => _user != null;

  PillSheetModel currentPillSheet;

  void subscribe() {
    userRepository
        .subscribe()
        .then((value) => this.notifyWith((model) => model.user = value));
  }

  static AppState watch(BuildContext context) {
    return context.watch();
  }

  static AppState read(BuildContext context) {
    return context.read();
  }

  Future<AppState> notifyWith(void update(AppState state)) {
    update(this);
    notifyListeners();
    return Future.value(this);
  }

  Future<T> updated<T>(T value, void update(AppState state, T value)) {
    update(this, value);
    return Future.value(value);
  }
}
