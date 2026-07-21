import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entrypoint.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_catalog_app.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // App Store スクリーンショットを Simulator 実描画で撮るためのカタログ起動分岐。
  // Firebase 初期化等の entrypoint() を通さず、スクショ用アプリだけを起動する。
  if (const bool.fromEnvironment('SCREENSHOT_CATALOG')) {
    Environment.flavor = Flavor.DEVELOP;
    WidgetsFlutterBinding.ensureInitialized();
    // DateTimeFormatter は Platform.localeName で DateFormat を作る。撮影時は Simulator の
    // 言語を言語ごとに切り替えるため、全ロケールの日付データを初期化しておく
    // (locale 引数なしは全ロケール初期化)。
    await initializeDateFormatting();
    runApp(const ScreenshotCatalogApp());
    return;
  }
  Environment.flavor = Flavor.DEVELOP;
  Environment.deleteUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError('This method should not call out of development');
    }
    (await SharedPreferences.getInstance()).setBool(
      BoolKey.didEndInitialSetting,
      false,
    );
    await FirebaseAuth.instance.currentUser?.delete();
  };
  Environment.signOutUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError('This method should not call out of development');
    }
    (await SharedPreferences.getInstance()).setBool(
      BoolKey.didEndInitialSetting,
      false,
    );
    // local notificationのみ解除（AlarmKit解除はRiverpodコンテナ内でのみ実行可能）
    final pendingNotifications = await localNotificationService.pendingReminderNotifications();
    await Future.wait(
      pendingNotifications.map(
        (p) => localNotificationService.cancelNotification(
          localNotificationID: p.id,
        ),
      ),
    );
    await FirebaseAuth.instance.signOut();
  };
  await entrypoint();
}
