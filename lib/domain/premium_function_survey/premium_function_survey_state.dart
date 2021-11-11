import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';

part 'premium_function_survey_state.freezed.dart';

@freezed
abstract class PremiumFunctionSurveyState
    implements _$PremiumFunctionSurveyState {
  PremiumFunctionSurveyState._();
  factory PremiumFunctionSurveyState({
    @Default([]) List<PremiumFunctionSurveyElementType> selectedElements,
    @Default("") String message,
  }) = _PremiumFunctionSurveyState;
}
