import 'package:Pilll/theme/color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'application/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja_JP');
  await Firebase.initializeApp();
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
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
