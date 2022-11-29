import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:flutter/material.dart';

class AppRouter {
// NOTE: This method call after user end all initialSetting
// OR user signed with 3rd party provider
// So, Don't forget when this function is edited. Both test necessary .
  static void endInitialSetting(BuildContext context, BoolSharedPreferences didEndInitialSettingNotifier) {
    analytics.logEvent(name: "end_initial_setting");
    didEndInitialSettingNotifier.set(true);
    Navigator.popUntil(context, (router) => router.isFirst);
  }

  static Future<void> routeToInitialSetting(BuildContext context, BoolSharedPreferences didEndInitialSettingNotifier) async {
    analytics.logEvent(name: "route_to_initial_settings");
    didEndInitialSettingNotifier.set(false);
    Navigator.popUntil(context, (router) => router.isFirst);
  }
}
