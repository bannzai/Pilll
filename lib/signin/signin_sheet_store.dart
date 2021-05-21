import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/boilerplate.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:riverpod/riverpod.dart';

final signinSheetStoreProvider =
    StateNotifierProvider.autoDispose.family<SigninSheetStore, bool>(
  (ref, isFixedLoginMode) =>
      SigninSheetStore(isFixedLoginMode, ref.watch(userServiceProvider)),
);

class SigninSheetStore extends StateNotifier<SigninSheetState> {
  final bool _isFixedLoginMode;
  final UserService _userService;
  SigninSheetStore(this._isFixedLoginMode, this._userService)
      : super(SigninSheetState()) {
    _reset();
  }
  _reset() {
    state = state.copyWith(isLoginMode: _isFixedLoginMode || state.isLoginMode);
  }

  toggleMode() {
    state = state.copyWith(isLoginMode: !state.isLoginMode);
  }

  bool get isLoginMode => _isFixedLoginMode || state.isLoginMode;

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
