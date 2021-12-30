import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';

part 'premium_function_survey_state.freezed.dart';

@freezed
class PremiumFunctionSurveyState with _$PremiumFunctionSurveyState {
  const PremiumFunctionSurveyState._();
  const factory PremiumFunctionSurveyState({
    @Default([]) List<PremiumFunctionSurveyElementType> selectedElements,
    @Default("") String message,
  }) = _PremiumFunctionSurveyState;
}
