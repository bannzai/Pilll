import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_state.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';

final premiumFunctionSurveyStoreProvider = StateNotifierProvider<
    PremiumFunctionSurveyStateStore, PremiumFunctionSurveyState>(
  (ref) => PremiumFunctionSurveyStateStore(ref.watch(userServiceProvider)),
);

class PremiumFunctionSurveyStateStore
    extends StateNotifier<PremiumFunctionSurveyState> {
  final UserService _userService;
  PremiumFunctionSurveyStateStore(this._userService)
      : super(PremiumFunctionSurveyState());

  handleCheckEvent(PremiumFunctionSurveyElementType element) {
    final copied = [...state.selectedElements];

    if (state.selectedElements.contains(element)) {
      state = state.copyWith(selectedElements: copied..remove(element));
    } else {
      state = state.copyWith(selectedElements: copied..add(element));
    }
  }

  inputMessage(String message) {
    state = state.copyWith(message: message);
  }

  Future<void> send() async {
    await _userService.sendPremiumFunctionSurvey(
        state.selectedElements, state.message);
  }
}
