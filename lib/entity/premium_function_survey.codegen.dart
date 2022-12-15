import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/features/premium_function_survey/premium_function_survey_element_type.dart';

part 'premium_function_survey.codegen.g.dart';
part 'premium_function_survey.codegen.freezed.dart';

@freezed
class PremiumFunctionSurvey with _$PremiumFunctionSurvey {
  @JsonSerializable(explicitToJson: true)
  const factory PremiumFunctionSurvey({
    required List<PremiumFunctionSurveyElementType> elements,
    required String message,
  }) = _PremiumFunctionSurvey;
  const PremiumFunctionSurvey._();
  factory PremiumFunctionSurvey.fromJson(Map<String, dynamic> json) =>
      _$PremiumFunctionSurveyFromJson(json);
}
