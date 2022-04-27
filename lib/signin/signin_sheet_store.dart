import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/boilerplate.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/signin/signin_sheet_state.codegen.dart';
import 'package:riverpod/riverpod.dart';

final signinSheetStoreProvider = StateNotifierProvider.autoDispose
    .family<SignInSheetStore, SignInSheetState, SignInSheetStateContext>(
  (ref, context) => SignInSheetStore(context, ref.watch(userDatabaseProvider)),
);

class SignInSheetStore extends StateNotifier<SignInSheetState> {
  final UserDatabase _userService;
  SignInSheetStore(SignInSheetStateContext context, this._userService)
      : super(SignInSheetState(context: context)) {
    reset();
  }

  reset() {
    state = state.copyWith(exception: null);
  }

  Future<SignInWithAppleState> handleApple() {
    if (state.isLoginMode) {
      analytics.logEvent(name: "signin_sheet_sign_in_apple");
      return signInWithApple().then((value) => value == null
          ? SignInWithAppleState.cancel
          : SignInWithAppleState.determined);
    } else {
      analytics.logEvent(name: "signin_sheet_link_with_apple");
      return callLinkWithApple(_userService);
    }
  }

  Future<SignInWithGoogleState> handleGoogle() {
    if (state.isLoginMode) {
      analytics.logEvent(name: "signin_sheet_sign_in_google");
      return signInWithGoogle().then((value) => value == null
          ? SignInWithGoogleState.cancel
          : SignInWithGoogleState.determined);
    } else {
      analytics.logEvent(name: "signin_sheet_link_with_google");
      return callLinkWithGoogle(_userService);
    }
  }

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  showHUD() {
    state = state.copyWith(isLoading: true);
  }

  hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}
