import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pilll/features/root/user_setup_page.dart';
import 'package:pilll/provider/shared_preference.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/root/root_page.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/datetime/debug_print.dart';
import 'package:pilll/utils/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final (_, sharedPreferences) = await (LocalNotificationService.setupTimeZone(), SharedPreferences.getInstance()).wait;

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

void connectToEmulator() {
  final domain = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false, host: '$domain:8080', sslEnabled: false);
}

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: firebaseAnalytics)],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          color: PilllColors.white,
          elevation: 3,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: PilllColors.secondary,
        ),
        primaryColor: PilllColors.secondary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
          fontFamily: FontFamily.number,
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ))),
        buttonTheme: const ButtonThemeData(
          buttonColor: PilllColors.primary,
          disabledColor: PilllColors.disable,
          textTheme: ButtonTextTheme.primary,
          colorScheme: ColorScheme.light(
            primary: PilllColors.secondary,
            secondary: PilllColors.accent,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return PilllColors.secondary;
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return PilllColors.secondary;
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return PilllColors.secondary;
            }
            return null;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return PilllColors.secondary;
            }
            return null;
          }),
        ),
      ),
      home: ProviderScope(
        child: RootPage(builder: (_, userID) => UserSetupPage(userID: userID)),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ja'),
    );
  }
}
