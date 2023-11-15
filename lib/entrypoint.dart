import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/utils/emulator/emulator.dart';
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
    await Firebase.initializeApp();
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

final navigatorKey = GlobalKey<NavigatorState>();
