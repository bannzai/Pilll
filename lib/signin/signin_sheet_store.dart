import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:riverpod/riverpod.dart';

final signinSheetStoreProvider = StateNotifierProvider(
  (ref) => SigninSheetStore(),
);

class SigninSheetStore extends StateNotifier<SigninSheetState> {
  SigninSheetStore() : super(SigninSheetState());

  toggleMode() {
    state = state.copyWith(isLoginMode: !state.isLoginMode);
  }
}
