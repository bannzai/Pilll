import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';

class PremiumFunctionSurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 46.5),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "プレミアム体験が終了しました",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "もしよければ、便利だと感じた機能を教えて下さい！ぜひ、あなたのご意見をお聞かせください。",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.roboto,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    child: Text("プレミアム機能の詳細はこちら",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w400,
                            color: TextColor.primary)),
                  ),
                  SizedBox(height: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...PremiumFunctionSurveyElementType.values.map(
                        (e) => PremiumFunctionSurveyElement(
                          isChecked: false,
                          elementType: e,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "その他ご意見等あれば教えて下さい",
                        style: TextStyle(
                            color: TextColor.main,
                            fontFamily: FontFamily.japanese,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: 'ご意見、ご要望、開発者へ伝えたい事等',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onChanged: (text) {},
                      ),
                    ],
                  ),
                ],
              ),
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
