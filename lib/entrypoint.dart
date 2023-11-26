import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/emulator/emulator.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/datetime/debug_print.dart';
import 'package:pilll/utils/environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> entrypoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await (MobileAds.instance.initialize(), Firebase.initializeApp()).wait;
    // QuickRecordの処理などFirebaseを使用するのでFirebase.initializeApp()の後に時刻する
    // また、同じくQuickRecordの処理開始までにMethodChannelが確立されていてほしいのでこの処理はなるべく早く実行する
    definedChannel();

    if (kDebugMode) {
      overrideDebugPrint();
    }
    if (Environment.isLocal) {
      connectToEmulator();
    }

    // ignore: prefer_typing_uninitialized_variables
    final (_, sharedPreferences, _) = await (
      LocalNotificationService.setupTimeZone(),
      SharedPreferences.getInstance(),
      setupRemoteConfig(),
    ).wait;

    // MEMO: FirebaseCrashlytics#recordFlutterError called dumpErrorToConsole in function.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
      ],
      child: const App(),
    ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

// TODO: [UseLocalNotification-Beta] 2023-11 このコメントを削除
// iOSはmethodChannel経由の方が呼ばれる。iOSはネイティブの方のコードで上書きされる模様。現在はAndroidのために定義
@pragma('vm:entry-point')
Future<void> handleNotificationAction(NotificationResponse notificationResponse) async {
  if (notificationResponse.actionId == actionIdentifier) {
    await LocalNotificationService.setupTimeZone();

    // 通知からの起動の時に、FirebaseAuth.instanceを参照すると、まだinitializeされてないよ．的なエラーが出る
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return;
    }

    try {
      analytics.logEvent(name: "handle_notification_action");

      final database = DatabaseConnection(firebaseUser.uid);

      final pillSheetGroup = await quickRecordTakePill(database);
      syncActivePillSheetValue(pillSheetGroup: pillSheetGroup);

      final cancelReminderLocalNotification = CancelReminderLocalNotification();
      // エンティティの変更があった場合にdatabaseの読み込みで最新の状態を取得するために、Future.microtaskで更新を待ってから処理を始める
      // hour,minute,番号を基準にIDを決定しているので、時間変更や番号変更時にそれまで登録されていたIDを特定するのが不可能なので全てキャンセルする
      await (Future.microtask(() => null), cancelReminderLocalNotification()).wait;

      final activePillSheet = pillSheetGroup?.activePillSheet;
      final user = (await database.userReference().get()).data();
      final setting = user?.setting;
      if (pillSheetGroup != null && activePillSheet != null && user != null && setting != null) {
        if (user.useLocalNotificationForReminder) {
          await RegisterReminderLocalNotification.run(
            pillSheetGroup: pillSheetGroup,
            activePillSheet: activePillSheet,
            premiumOrTrial: user.isPremium || user.isTrial,
            setting: setting,
          );
        }
      }
    } catch (e, st) {
      errorLogger.recordError(e, st);

      // errorLoggerに記録した後に実行する。これも失敗する可能性がある
      await localNotificationService.plugin.show(
        fallbackNotificationIdentifier,
        "服用記録が失敗した可能性があります",
        "アプリを開いてご確認ください",
        null,
      );
    }
  }
}
