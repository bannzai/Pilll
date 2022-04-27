import 'package:pilll/domain/premium_function_survey/premium_function_survey_element_type.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_state.codegen.dart';
import 'package:pilll/database/user.dart';
import 'package:riverpod/riverpod.dart';

final premiumFunctionSurveyStoreProvider = StateNotifierProvider<
    PremiumFunctionSurveyStateStore, PremiumFunctionSurveyState>(
  (ref) => PremiumFunctionSurveyStateStore(ref.watch(userDatastoreProvider)),
);

class PremiumFunctionSurveyStateStore
    extends StateNotifier<PremiumFunctionSurveyState> {
  final UserDatastore _userService;
  PremiumFunctionSurveyStateStore(this._userService)
      : super(const PremiumFunctionSurveyState());

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
