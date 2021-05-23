import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/boilerplate.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:riverpod/riverpod.dart';

final signinSheetStoreProvider =
    StateNotifierProvider.autoDispose.family<SigninSheetStore, bool>(
  (ref, isLoginMode) =>
      SigninSheetStore(isLoginMode, ref.watch(userServiceProvider)),
);

class SigninSheetStore extends StateNotifier<SigninSheetState> {
  final bool isLoginMode;
  final UserService _userService;
  SigninSheetStore(this.isLoginMode, this._userService)
      : super(SigninSheetState(isLoginMode: isLoginMode));

  Future<SigninWithAppleState> handleApple() {
    if (state.isLoginMode) {
      return signInWithApple().then((value) => value == null
          ? SigninWithAppleState.cancel
          : SigninWithAppleState.determined);
    } else {
      return callLinkWithApple(_userService);
    }
  }

  Future<SigninWithGoogleState> handleGoogle() {
    if (state.isLoginMode) {
      return signInWithGoogle().then((value) => value == null
          ? SigninWithGoogleState.cancel
          : SigninWithGoogleState.determined);
    } else {
      return callLinkWithGoogle(_userService);
    }
  }
}
