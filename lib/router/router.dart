import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/initial_setting_1_page.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/service/push_notification.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes() {
    return {
      Routes.root: (BuildContext context) => ProviderScope(
            child: Root(key: rootKey),
          ),
      Routes.initialSetting: (BuildContext context) =>
          ProviderScope(child: InitialSetting1Page()),
      Routes.main: (BuildContext context) =>
          ProviderScope(child: HomePage(key: homeKey)),
    };
  }

// NOTE: This method call after user end all initialSetting
// OR user signed with 3rd party provider
// So, Don't forget when this function is edited. Both test necessary .
  static void endInitialSetting(BuildContext context) {
    analytics.logEvent(name: "end_initial_setteing");
    SharedPreferences.getInstance().then((storage) {
      storage.setBool(BoolKey.didEndInitialSetting, true);
      requestNotificationPermissions().then((value) {
        listenNotificationEvents();
        Navigator.popUntil(context, (router) => router.isFirst);
        Navigator.pushReplacementNamed(context, Routes.main);
      });
    });
  }

  static void signinAccount(BuildContext context, LinkAccountType accountType) {
    print("signinAccount: ${FirebaseAuth.instance.currentUser?.uid}");
    return endInitialSetting(context);
  }
}

class Routes {
  static String root = '/';
  static String initialSetting = '/initial-setting';
  static String main = '/main';
}
