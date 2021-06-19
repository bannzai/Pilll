import 'package:pilll/analytics.dart';
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
      : super(SigninSheetState(isLoginMode: isLoginMode)) {
    reset();
  }

  reset() {
    state = state.copyWith(exception: null);
  }

  Future<SigninWithAppleState> handleApple() {
    if (state.isLoginMode) {
      analytics.logEvent(name: "signin_sheet_sign_in_apple");
      return signInWithApple().then((value) => value == null
          ? SigninWithAppleState.cancel
          : SigninWithAppleState.determined);
    } else {
      analytics.logEvent(name: "signin_sheet_link_with_apple");
      return callLinkWithApple(_userService);
    }
  }

  Future<SigninWithGoogleState> handleGoogle() {
    if (state.isLoginMode) {
      analytics.logEvent(name: "signin_sheet_sign_in_google");
      return signInWithGoogle().then((value) => value == null
          ? SigninWithGoogleState.cancel
          : SigninWithGoogleState.determined);
    } else {
      analytics.logEvent(name: "signin_sheet_link_with_google");
      return callLinkWithGoogle(_userService);
    }
  }

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }
}
