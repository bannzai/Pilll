import 'package:flutter/material.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';

class PremiumFunctionSurveyElement extends StatelessWidget {
  final bool isChecked;
  final PremiumFunctionSurveyElementType elementType;

  const PremiumFunctionSurveyElement({
    Key? key,
    required this.isChecked,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(value: isChecked, onChanged: (value) {}),
      Text(_word),
    ]);
  }

  String get _word {
    switch (elementType) {
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
