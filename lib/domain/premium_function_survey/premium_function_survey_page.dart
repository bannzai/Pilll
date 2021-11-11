import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';

class PremiumFunctionSurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
      ),
    );
  }
}

extension PremiumFunctionSurveyPageRoutes on PremiumFunctionSurveyPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PremiumFunctionSurveyPage"),
      builder: (_) => PremiumFunctionSurveyPage(),
      fullscreenDialog: true,
    );
  }
}
