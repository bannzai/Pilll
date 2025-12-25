import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/root/page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/l10n/app_localizations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

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
          color: AppColors.white,
          elevation: 3,
          foregroundColor: TextColor.main,
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        primaryColor: AppColors.secondary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(fontFamily: FontFamily.number, fontWeight: FontWeight.w500, fontSize: 24),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primary,
          disabledColor: AppColors.disable,
          textTheme: ButtonTextTheme.primary,
          colorScheme: ColorScheme.light(primary: AppColors.secondary, secondary: AppColors.accent),
        ),
        datePickerTheme: const DatePickerThemeData(backgroundColor: Colors.white, headerBackgroundColor: AppColors.primary),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondary;
            }
            return null;
          }),
          trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondary;
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondary;
            }

            return null;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondary;
            }
            return null;
          }),
        ),
      ),
      home: const ProviderScope(child: RootPage()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
