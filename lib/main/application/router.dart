import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/main/home/home.dart';
import 'package:Pilll/main/root/root.dart';
import 'package:flutter/material.dart';

class Router {
  static Map<String, WidgetBuilder> routes() {
    return {
      Routes.root: (BuildContext context) => (Root()),
      Routes.initialSetting: (BuildContext context) => (InitialSetting()),
      Routes.main: (BuildContext context) => (HomePage()),
    };
  }
}

class Routes {
  static String root = '/';
  static String initialSetting = '/initial-setting';
  static String main = '/main';
}
