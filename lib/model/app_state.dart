import 'package:Pilll/model/initial_setting.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  InitialSettingModel _initialSetting = InitialSettingModel();
  InitialSettingModel get initialSetting => _initialSetting;

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
