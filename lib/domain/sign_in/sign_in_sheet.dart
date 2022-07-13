import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/alert_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet_state.codegen.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet_store.dart';

abstract class SignInSheetConst {
  static const double height = 340;
}

class SignInSheet extends HookConsumerWidget {
  final SignInSheetStateContext stateContext;
  final Function(LinkAccountType)? onSignIn;

  const SignInSheet({
    Key? key,
    required this.stateContext,
    required this.onSignIn,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(signinSheetStoreProvider(stateContext).notifier);
    final state = ref.watch(signinSheetStoreProvider(stateContext));
    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
        error: state.exception,
        reload: () => store.reset(),
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
                  SvgPicture.asset("images/draggable_bar.svg", height: 6),
                  const SizedBox(height: 24),
                  Text(state.title,
                      textAlign: TextAlign.center,
                      style: TextColorStyle.main.merge(FontType.sBigTitle)),
                  const SizedBox(height: 16),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: TextColorStyle.main.merge(FontType.assisting)),
                  const SizedBox(height: 24),
                  _appleButton(context, store, state),
                  const SizedBox(height: 24),
                  _googleButton(context, store, state),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appleButton(
    BuildContext context,
    SignInSheetStore store,
    SignInSheetState state,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(PilllColors.appleBlack),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      onPressed: () async {
        analytics.logEvent(name: "signin_sheet_selected_apple");
        store.showHUD();
        try {
          final signinState = await store.handleApple();
          switch (signinState) {
            case SignInWithAppleState.determined:
              Navigator.of(context).pop();
              onSignIn?.call(LinkAccountType.apple);
              return;
            case SignInWithAppleState.cancel:
              return;
          }
        } catch (error) {
          if (error is AlertError) {
            showErrorAlertWithError(context, error);
          } else {
            store.handleException(error);
          }
        } finally {
          store.hideHUD();
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
              SvgPicture.asset("images/apple_icon.svg"),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  state.appleButtonText,
                  style: FontType.subTitle.merge(TextColorStyle.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleButton(
    BuildContext context,
    SignInSheetStore store,
    SignInSheetState state,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(color: PilllColors.secondary),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      onPressed: () async {
        analytics.logEvent(name: "signin_sheet_selected_google");
        store.showHUD();
        try {
          final signinState = await store.handleGoogle();
          switch (signinState) {
            case SignInWithGoogleState.determined:
              Navigator.of(context).pop();
              onSignIn?.call(LinkAccountType.google);
              break;
            case SignInWithGoogleState.cancel:
              return;
          }
        } catch (error) {
          if (error is AlertError) {
            showErrorAlertWithError(context, error);
          } else {
            store.handleException(error);
          }
        } finally {
          store.hideHUD();
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
              SvgPicture.asset("images/google_icon.svg"),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  state.googleButtonText,
                  style: FontType.subTitle.merge(TextColorStyle.main),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showSignInSheet(BuildContext context, SignInSheetStateContext stateContext,
    Function(LinkAccountType)? onSignIn) {
  analytics.setCurrentScreen(screenName: "SigninSheet");
  showModalBottomSheet(
    context: context,
    builder: (context) => SignInSheet(
      stateContext: stateContext,
      onSignIn: onSignIn,
    ),
    backgroundColor: Colors.transparent,
  );
}
