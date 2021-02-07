import 'package:Pilll/domain/initial_setting/initial_setting_1_page.dart';
import 'package:Pilll/domain/home/home_page.dart';
import 'package:Pilll/domain/root/root.dart';
import 'package:Pilll/service/push_notification.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes() {
    return {
      Routes.root: (BuildContext context) => ProviderScope(
            child: Root(key: rootKey),
          ),
      Routes.initialSetting: (BuildContext context) =>
          ProviderScope(child: InitialSetting1Page()),
      Routes.main: (BuildContext context) => ProviderScope(child: HomePage()),
    };
  }

  static void endInitialSetting(BuildContext context) {
    SharedPreferences.getInstance().then((storage) {
      storage.setBool(BoolKey.didEndInitialSetting, true);
      requestNotificationPermissions();
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
