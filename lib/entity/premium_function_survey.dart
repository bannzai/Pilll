import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';

part 'premium_function_survey.g.dart';
part 'premium_function_survey.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class PremiumFunctionSurvey with _$PremiumFunctionSurvey {
const factory PremiumFunctionSurvey({
    required List<PremiumFunctionSurveyElementType> elements,
    required String message,
  }) = _PremiumFunctionSurvey;
  Preconst PremiumFunctionSurvey._();
const factory PremiumFunctionSurvey.fromJson(Map<String, dynamic> json) =>
      _$PremiumFunctionSurveyFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_PremiumFunctionSurveyToJson(this as _$_PremiumFunctionSurvey);
}
