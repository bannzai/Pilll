import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/native/ios_keychain_migration.dart';
import 'package:pilll/util/datetime/debug_print.dart';
import 'package:pilll/util/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> entrypoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    if (Platform.isIOS) {
      if (!(await isMigratedSharedKeychain())) {
        final isSuccess = await iOSKeychainMigrateToSharedKeychain();
        if (!isSuccess) {
          // おおむねKeychainにアクセスできずに失敗する。
          // それは異常事態なのでユーザーに起動し直してもらうで良い
          exit(1);
        }
      }
    }

    // QuickRecordの処理などFirebaseを使用するのでFirebase.initializeApp()の後に時刻する
    // また、同じくQuickRecordの処理開始までにMethodChannelが確立されていてほしいのでこの処理はなるべく早く実行する
    definedChannel();

    if (kDebugMode) {
      overrideDebugPrint();
    }
    if (Environment.isLocal) {
      connectToEmulator();
    }

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return UniversalErrorPage(
        error: details.exception.toString(),
        child: null,
        reload: () {
          rootKey.currentState?.reload();
        },
      );
    };
    // MEMO: FirebaseCrashlytics#recordFlutterError called dumpErrorToConsole in function.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const ProviderScope(child: App()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

void connectToEmulator() {
  final domain = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false, host: '$domain:8080', sslEnabled: false);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: firebaseAnalytics)],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          color: PilllColors.white,
          elevation: 3,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: PilllColors.primary,
        ),
        primaryColor: PilllColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        toggleableActiveColor: PilllColors.primary,
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: FontType.xBigTitle)),
        buttonTheme: const ButtonThemeData(
          buttonColor: PilllColors.secondary,
          disabledColor: PilllColors.disable,
          textTheme: ButtonTextTheme.primary,
          colorScheme: ColorScheme.light(
            primary: PilllColors.primary,
            secondary: PilllColors.accent,
          ),
        ),
      ),
      home: ProviderScope(
        child: Root(
          key: rootKey,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ja'),
    );
  }
}
