import 'package:pilll/provider/old_typed_shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:flutter/material.dart';

class AppRouter {
// NOTE: This method call after user end all initialSetting
// OR user signed with 3rd party provider
// So, Don't forget when this function is edited. Both test necessary .
  static Future<void> endInitialSetting(NavigatorState navigator, BoolSharedPreferences didEndInitialSettingNotifier) async {
    analytics.logEvent(name: "end_initial_setting");
    await didEndInitialSettingNotifier.set(true);
    navigator.popUntil((router) => router.isFirst);
  }

  static Future<void> routeToInitialSetting(NavigatorState navigator, BoolSharedPreferences didEndInitialSettingNotifier) async {
    analytics.logEvent(name: "route_to_initial_settings");
    await didEndInitialSettingNotifier.set(false);
    navigator.popUntil((router) => router.isFirst);
  }
}
