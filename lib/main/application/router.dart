import 'package:Pilll/initial_setting/initialsetting.dart';
import 'package:Pilll/main/home/home.dart';
import 'package:Pilll/main/root/root.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Router {
  static Map<String, WidgetBuilder> routes() {
    return {
      Routes.root: (BuildContext context) => (Root()),
      Routes.initialSetting: (BuildContext context) => (InitialSetting()),
      Routes.main: (BuildContext context) => (HomePage()),
    };
  }

  static void endInitialSetting(BuildContext context) {
    SharedPreferences.getInstance().then((storage) {
      storage.setBool(BoolKey.didEndInitialSetting, true);
      Navigator.popUntil(context, (router) => router.isFirst);
      Navigator.pushReplacementNamed(context, Routes.main);
    });
  }
}

class Routes {
  static String root = '/';
  static String initialSetting = '/initial-setting';
  static String main = '/main';
}
