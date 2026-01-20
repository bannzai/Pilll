import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/boilerplate.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/error/error_alert.dart';

abstract class SignInSheetConst {
  static const double height = 340;
}

enum SignInSheetStateContext { initialSetting, recordPage, premium, setting }

class SignInSheet extends HookConsumerWidget {
  final SignInSheetStateContext stateContext;
  final Function(LinkAccountType)? onSignIn;

  const SignInSheet({
    super.key,
    required this.stateContext,
    required this.onSignIn,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final linkApple = ref.watch(linkAppleProvider);
    final linkGoogle = ref.watch(linkGoogleProvider);

    return HUD(
      shown: isLoading.value,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 333,
          minHeight: 300,
          minWidth: MediaQuery.of(context).size.width,
        ),
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                SvgPicture.asset('images/draggable_bar.svg', height: 6),
                const SizedBox(height: 24),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: TextColor.main,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
                const SizedBox(height: 24),
                _appleButton(context, linkApple, isLoading),
                const SizedBox(height: 24),
                _googleButton(context, linkGoogle, isLoading),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appleButton(
    BuildContext context,
    LinkApple linkApple,
    ValueNotifier<bool> isLoading,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.appleBlack),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      onPressed: () async {
        analytics.logEvent(name: 'signin_sheet_selected_apple');
        isLoading.value = true;
        final navigator = Navigator.of(context);
        try {
          final signinState = await _handleApple(linkApple);
          switch (signinState) {
            case SignInWithAppleState.determined:
              navigator.pop();
              onSignIn?.call(LinkAccountType.apple);
              return;
            case SignInWithAppleState.cancel:
              return;
          }
        } catch (error) {
          if (context.mounted) showErrorAlert(context, error);
        } finally {
          isLoading.value = false;
        }
      },
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('images/apple_icon.svg'),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _appleButtonText,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: TextColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleButton(
    BuildContext context,
    LinkGoogle linkGoogle,
    ValueNotifier<bool> isLoading,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      onPressed: () async {
        analytics.logEvent(name: 'signin_sheet_selected_google');
        isLoading.value = true;
        final navigator = Navigator.of(context);
        try {
          final signinState = await _handleGoogle(linkGoogle);
          switch (signinState) {
            case SignInWithGoogleState.determined:
              navigator.pop();
              onSignIn?.call(LinkAccountType.google);
              break;
            case SignInWithGoogleState.cancel:
              return;
          }
        } catch (error) {
          if (context.mounted) showErrorAlert(context, error);
        } finally {
          isLoading.value = false;
        }
      },
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('images/google_icon.svg'),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _googleButtonText,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: TextColor.main,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isLoginMode {
    switch (stateContext) {
      case SignInSheetStateContext.initialSetting:
        return true;
      case SignInSheetStateContext.recordPage:
        return false;
      case SignInSheetStateContext.premium:
        return false;
      case SignInSheetStateContext.setting:
        return false;
    }
  }

  String get _title {
    switch (stateContext) {
      case SignInSheetStateContext.initialSetting:
        return L.login;
      case SignInSheetStateContext.recordPage:
        return L.registerAccount;
      case SignInSheetStateContext.premium:
        return L.beforePremiumRegistration;
      case SignInSheetStateContext.setting:
        return L.registerAccount;
    }
  }

  String get _message {
    switch (stateContext) {
      case SignInSheetStateContext.initialSetting:
        return L.createNewAccountIfNotLoggedIn;
      case SignInSheetStateContext.recordPage:
        return L.registerAccountForDataTransfer;
      case SignInSheetStateContext.premium:
        return L.registerAccountToKeepData;
      case SignInSheetStateContext.setting:
        return L.registerAccountForDataTransfer;
    }
  }

  String get _appleButtonText {
    switch (stateContext) {
      case SignInSheetStateContext.initialSetting:
        return L.signInWith(LinkAccountType.apple.loginContentName);
      case SignInSheetStateContext.recordPage:
        return L.registerWith(LinkAccountType.apple.loginContentName);
      case SignInSheetStateContext.premium:
        return L.registerWith(LinkAccountType.apple.loginContentName);
      case SignInSheetStateContext.setting:
        return L.registerWith(LinkAccountType.apple.loginContentName);
    }
  }

  String get _googleButtonText {
    switch (stateContext) {
      case SignInSheetStateContext.initialSetting:
        return L.signInWith(LinkAccountType.google.loginContentName);
      case SignInSheetStateContext.recordPage:
        return L.registerWith(LinkAccountType.google.loginContentName);
      case SignInSheetStateContext.premium:
        return L.registerWith(LinkAccountType.google.loginContentName);
      case SignInSheetStateContext.setting:
        return L.registerWith(LinkAccountType.google.loginContentName);
    }
  }

  Future<SignInWithAppleState> _handleApple(LinkApple linkApple) {
    if (_isLoginMode) {
      analytics.logEvent(name: 'signin_sheet_sign_in_apple');
      return signInWithApple().then(
        (value) => value == null ? SignInWithAppleState.cancel : SignInWithAppleState.determined,
      );
    } else {
      analytics.logEvent(name: 'signin_sheet_link_with_apple');
      return callLinkWithApple(linkApple);
    }
  }

  Future<SignInWithGoogleState> _handleGoogle(LinkGoogle linkGoogle) {
    if (_isLoginMode) {
      analytics.logEvent(name: 'signin_sheet_sign_in_google');
      return signInWithGoogle().then(
        (value) => value == null ? SignInWithGoogleState.cancel : SignInWithGoogleState.determined,
      );
    } else {
      analytics.logEvent(name: 'signin_sheet_link_with_google');
      return callLinkWithGoogle(linkGoogle);
    }
  }
}

void showSignInSheet(
  BuildContext context,
  SignInSheetStateContext stateContext,
  Function(LinkAccountType)? onSignIn,
) {
  analytics.logScreenView(screenName: 'SigninSheet');
  showModalBottomSheet(
    context: context,
    builder: (context) => SignInSheet(stateContext: stateContext, onSignIn: onSignIn),
    backgroundColor: Colors.transparent,
  );
}
