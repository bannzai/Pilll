import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/service/push_notification.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
// NOTE: This method call after user end all initialSetting
// OR user signed with 3rd party provider
// So, Don't forget when this function is edited. Both test necessary .
  static void endInitialSetting(BuildContext context) {
    analytics.logEvent(name: "end_initial_setting");
    SharedPreferences.getInstance().then((storage) {
      storage.setBool(BoolKey.didEndInitialSetting, true);
      Navigator.popUntil(context, (router) => router.isFirst);
// TODO: Remove
//      requestNotificationPermissions().then((value) {
//        listenNotificationEvents();
//        // rootKey.currentState?.showHome();
//      });
    });
  }

  static void signInAccount(BuildContext context) {
    analytics.logEvent(name: "initial_setting_signin_account", parameters: {"uid": FirebaseAuth.instance.currentUser?.uid});
    return endInitialSetting(context);
  }

  static Future<void> routeToInitialSetting(BuildContext context) async {
    analytics.logEvent(name: "route_to_initial_settings");
    final storage = await SharedPreferences.getInstance();
    await storage.setBool(BoolKey.didEndInitialSetting, false);
    Navigator.popUntil(context, (router) => router.isFirst);
    // rootKey.currentState?.reload();
  }
}
