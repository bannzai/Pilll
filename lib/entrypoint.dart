import 'dart:async';
import 'dart:io';

import 'package:Pilll/analytics.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/entity/user_error.dart';
import 'package:Pilll/error/universal_error_page.dart';
import 'package:Pilll/global_method_channel.dart';
import 'package:Pilll/router/router.dart';
import 'package:Pilll/util/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'router/router.dart';

Future<void> entrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja_JP');
  await Firebase.initializeApp();
  // MEMO: FirebaseCrashlytics#recordFlutterError called dumpErrorToConsole in function.
  if (Environment.isLocal) {
    connectToEmulator();
  }
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return UniversalErrorPage(
      error: UserDisplayedError(
        displayedMessage: details.exception.toString(),
      ),
    );
  };
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  definedChannel();
  runZonedGuarded(() {
    runApp(ProviderScope(child: App()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

void connectToEmulator() {
  final domain = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: false, host: '$domain:8080', sslEnabled: false);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(brightness: Brightness.light, centerTitle: true),
        primaryColor: PilllColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: PilllColors.accent,
        buttonTheme: ButtonThemeData(
          buttonColor: PilllColors.secondary,
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
