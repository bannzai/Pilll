import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/util/environment.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumFunctionSurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text(
                "プレミアム体験が終了しました",
                style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showPremiumFunctionSurveyPage(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  if (Environment.isDevelopment) {
    sharedPreferences..setBool(BoolKey.isAlreadyShowPremiumSurvey, false);
  }
  if (sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumSurvey) ?? false) {
    return;
  }
  sharedPreferences..setBool(BoolKey.isAlreadyShowPremiumSurvey, true);

  analytics.setCurrentScreen(screenName: "PremiumFunctionSurveyPage");
  showDialog(
    context: context,
    builder: (context) {
      return PremiumFunctionSurveyPage();
    },
  );
}
