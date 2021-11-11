import 'dart:async';

import 'package:pilll/domain/premium_function_survey/premium_function_survey_element.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_state.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final premiumFunctionSurveyStoreProvider = StateNotifierProvider(
  (ref) => PremiumFunctionSurveyStateStore(),
);

class PremiumFunctionSurveyStateStore
    extends StateNotifier<PremiumFunctionSurveyState> {
  PremiumFunctionSurveyStateStore() : super(PremiumFunctionSurveyState());

  handleCheckEvent(PremiumFunctionSurveyElementType element) {
    final copied = [...state.selectedElements];

    if (state.selectedElements.contains(element)) {
      state = state.copyWith(selectedElements: copied..remove(element));
    } else {
      state = state.copyWith(selectedElements: copied..add(element));
    }
  }
}
