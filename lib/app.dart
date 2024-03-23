import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pilll/features/home/home_page.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/features/root/resolver/force_update.dart';
import 'package:pilll/features/root/resolver/initial_setting_or_app_page.dart';
import 'package:pilll/features/root/resolver/show_paywall_on_app_launch.dart';
import 'package:pilll/features/root/resolver/skip_initial_setting.dart';
import 'package:pilll/features/root/resolver/user_setup.dart';
import 'package:pilll/features/root/resolver/user_sign_in.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/root/root_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: firebaseAnalytics)],
      theme: ThemeData(
        useMaterial3: false,
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
        child: RootPage(
          builder: (_) => ForceUpdate(
            builder: (_) => UserSignIn(
              builder: (_, userID) => UserSetup(
                userID: userID,
                builder: (_) => InitialSettingOrAppPage(
                  initialSettingPageBuilder: (_) => ShowPaywallOnAppLaunch(
                    builder: (_) => SkipInitialSetting(
                      initialSettingPageBuilder: (context) => InitialSettingPillSheetGroupPageRoute.screen(),
                      homePageBuilder: (_) => const HomePage(),
                    ),
                  ),
                  homePageBuilder: (_) => const HomePage(),
                ),
              ),
            ),
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ja'),
    );
  }
}
