import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/main.dart';
import 'package:flutter/material.dart';

class Router {
  static Map<String, WidgetBuilder> routes() {
    return {
      Routes.root: (BuildContext context) => (MyHomePage()),
      Routes.initialSetting: (BuildContext context) => (InitialSetting()),
      Routes.main: (BuildContext context) => (MyHomePage()),
    };
  }
}

class Routes {
  static String root = '/';
  static String initialSetting = '/initial-setting';
  static String main = '/main';
}
