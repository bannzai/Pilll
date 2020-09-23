import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/theme/color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'main/application/router.dart';
import 'model/auth_user.dart';

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
        ChangeNotifierProvider<InitialSettingModel>(
            create: (_) => InitialSettingModel()),
        ChangeNotifierProvider<AuthUser>(create: (_) => AuthUser()),
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
            minWidth: 180,
            height: 44,
            buttonColor: PilllColors.enable,
            disabledColor: PilllColors.disable,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        routes: Router.routes(),
      ),
    );
  }
}
