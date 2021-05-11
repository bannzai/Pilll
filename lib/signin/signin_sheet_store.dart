import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/boilerplate.dart';
import 'package:pilll/auth/util.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:riverpod/riverpod.dart';

final signinSheetStoreProvider = StateNotifierProvider(
  (ref) => SigninSheetStore(ref.watch(userServiceProvider)),
);

class SigninSheetStore extends StateNotifier<SigninSheetState> {
  final UserService _userService;
  SigninSheetStore(this._userService) : super(SigninSheetState());

  toggleMode() {
    state = state.copyWith(isLoginMode: !state.isLoginMode);
  }

  Future<SigninWithAppleState> handleApple() {
    if (state.isLoginMode) {
      return signInWithApple().then((value) => value == null
          ? SigninWithAppleState.cancel
          : SigninWithAppleState.determined);
    } else {
      return callLinkWithApple(_userService);
    }
  }
}
