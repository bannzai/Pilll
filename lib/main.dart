import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'main/application/router.dart';

void main() {
  initializeDateFormatting('ja_JP');
  // debugPaintSizeEnabled = true;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (_) => User.user(),
          lazy: true,
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          lazy: false,
        )
      ],
      child: MaterialApp(
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
        routes: Router.routes(),
      ),
    );
  }
}
