import 'package:Pilll/main/record/pill_sheet_model.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'main/application/router.dart';
import 'main/application/user.dart';
import 'main/home/home.dart';

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
          create: (_) => InitialSettingModel(),
        ),
        ChangeNotifierProvider<PillSheetModel>(
          create: (_) => MainPillSheetModel(PillSheetType.pillsheet_21),
        ),
        ChangeNotifierProvider<User>(
          create: (_) => User()),
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
