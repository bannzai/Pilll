import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:pilll/signin/signin_sheet_store.dart';

abstract class SigninSheetConst {
  static final double height = 340;
}

class SigninSheet extends HookWidget {
  final bool isFixedLoginMode;
  final Function(LinkAccountType) callback;

  SigninSheet({
    required this.isFixedLoginMode,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    final store = useProvider(signinSheetStoreProvider(isFixedLoginMode));
    final state = useProvider(signinSheetStoreProvider(isFixedLoginMode).state);
    return Container(
      constraints: BoxConstraints(maxHeight: 360, minHeight: 300),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset("images/draggable_bar.svg", height: 6),
            Text(state.title,
                textAlign: TextAlign.center,
                style: TextColorStyle.main.merge(FontType.sBigTitle)),
            Text(state.message,
                textAlign: TextAlign.center,
                style: TextColorStyle.main.merge(FontType.assisting)),
            _appleButton(context, store, state),
            _googleButton(context, store, state),
          ],
        ),
      ),
    );
  }

  Widget _appleButton(
    BuildContext context,
    SigninSheetStore store,
    SigninSheetState state,
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
      onPressed: () {
        analytics.logEvent(name: "signin_sheet_selected_apple");
        store.handleApple().then((value) {
          switch (value) {
            case SigninWithAppleState.determined:
              Navigator.of(context).pop();
              callback(LinkAccountType.apple);
              break;
            case SigninWithAppleState.cancel:
              return;
          }
        }, onError: (error) {
          if (error is UserDisplayedError) {
            showErrorAlertWithError(context, error);
          } else {
            rootKey.currentState?.onError(error);
          }
        });
      },
      child: Container(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
    SigninSheetStore store,
    SigninSheetState state,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(color: PilllColors.secondary),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      onPressed: () async {
        analytics.logEvent(name: "signin_sheet_selected_google");
        store.handleGoogle().then((value) {
          switch (value) {
            case SigninWithGoogleState.determined:
              Navigator.of(context).pop();
              callback(LinkAccountType.google);
              break;
            case SigninWithGoogleState.cancel:
              return;
          }
        }, onError: (error) {
          if (error is UserDisplayedError) {
            showErrorAlertWithError(context, error);
          } else {
            rootKey.currentState?.onError(error);
          }
        });
      },
      child: Container(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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

showSigninSheet(BuildContext context, bool isFixedLoginMode,
    Function(LinkAccountType) callback) {
  analytics.setCurrentScreen(screenName: "SigninSheet");
  showModalBottomSheet(
    context: context,
    builder: (context) => SigninSheet(
      isFixedLoginMode: isFixedLoginMode,
      callback: callback,
    ),
    backgroundColor: Colors.transparent,
  );
}
