import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pilll/features/home/home_page.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/features/root/resolver/force_update.dart';
import 'package:pilll/features/root/resolver/initial_setting_or_app_page.dart';
import 'package:pilll/features/root/resolver/show_paywall_on_app_launch.dart';
import 'package:pilll/features/root/resolver/skip_initial_setting.dart';
import 'package:pilll/features/root/resolver/user_setup.dart';
import 'package:pilll/features/root/resolver/user_sign_in.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/root/root_page.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/utils/emulator/emulator.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/datetime/debug_print.dart';
import 'package:pilll/utils/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
