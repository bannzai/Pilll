import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element.dart';

part 'premium_function_survey_state.freezed.dart';

@freezed
abstract class PremiumFunctionSurveyState
    implements _$PremiumFunctionSurveyState {
  PremiumFunctionSurveyState._();
  factory PremiumFunctionSurveyState({
    @Default([]) List<PremiumFunctionSurveyElement> elements,
  }) = _PremiumFunctionSurveyState;
}
