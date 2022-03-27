import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_state.codegen.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_store.dart';

class PremiumFunctionSurveyElement extends StatelessWidget {
  final PremiumFunctionSurveyStateStore store;
  final PremiumFunctionSurveyState state;
  final PremiumFunctionSurveyElementType element;

  const PremiumFunctionSurveyElement({
    Key? key,
    required this.store,
    required this.state,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          child: SizedBox(
            width: 34,
            height: 34,
            child: Checkbox(
              value: state.selectedElements.contains(element),
              onChanged: (isOn) {
                analytics.logEvent(
                    name: "toggle_premium_survey_check_box",
                    parameters: {"isOn": isOn, "element": element.toString()});
                store.handleCheckEvent(element);
              },
              checkColor: PilllColors.white,
              activeColor: PilllColors.secondary,
            ),
          ),
          data: ThemeData(
              primaryColor: PilllColors.thinSecondary,
              unselectedWidgetColor: PilllColors.secondary),
        ),
        Text(_word,
            style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: TextColor.main)),
      ],
    );
  }

  String get _word {
    switch (element) {
      case PremiumFunctionSurveyElementType.quickRecord:
        return "通知から服用記録できる";
      case PremiumFunctionSurveyElementType.pillNumberOnPushNotification:
        return "通知に今日飲むピル番号が表示される";
      case PremiumFunctionSurveyElementType.pillSheetModifiedHistory:
        return "服用履歴が見れる";
      case PremiumFunctionSurveyElementType.showingDate:
        return "ピルシートの日付表示";
      case PremiumFunctionSurveyElementType.automaticallyCreatePillSheet:
        return "新しいシートの自動追加";
      case PremiumFunctionSurveyElementType.menstruationHistory:
        return "生理履歴が全て見れる";
      case PremiumFunctionSurveyElementType.menstruationAnalytics:
        return "生理周期 / 日数の平均が分かる";
    }
  }
}
