import 'dart:async';

import 'package:Pilll/analytics.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/service/push_notification.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'router/router.dart';

Future<void> entrypoint() async {
  // MEMO: FirebaseCrashlytics#recordFlutterError called dumpErrorToConsole in function.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja_JP');
  await Firebase.initializeApp();
  requestNotificationPermissions();
  runZonedGuarded(() {
    runApp(ProviderScope(child: App()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
        primaryColor: PilllColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: PilllColors.accent,
        buttonTheme: ButtonThemeData(
          buttonColor: PilllColors.enable,
          disabledColor: PilllColors.disable,
          textTheme: ButtonTextTheme.primary,
          colorScheme: ColorScheme.light(
            primary: PilllColors.primary,
          ),
        ),
      ),
      routes: AppRouter.routes(),
    );
  }
}
