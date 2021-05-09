import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          height: 340,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset("images/draggable_bar.svg", height: 6),
              Text("アカウント登録",
                  textAlign: TextAlign.center,
                  style: TextColorStyle.main.merge(FontType.xBigTitle)),
              Text(
                "アカウント登録すると\nデータの引き継ぎが可能になります",
                textAlign: TextAlign.center,
              ),
              _appleButton(),
              _googleButton(),
              SecondaryButton(onPressed: () {}, text: "ログイン")
            ],
          ),
        );
      },
    );
  }

  Widget _appleButton() {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(PilllColors.appleBlack),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      onPressed: () async {},
      child: Container(
        width: 220,
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
                  'Apple アカウントで登録',
                  style: FontType.subTitle.merge(TextColorStyle.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleButton() {
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
      onPressed: () async {},
      child: Container(
        width: 220,
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
                  'Google アカウントで登録',
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

showSigninSheet(BuildContext context) {
  analytics.setCurrentScreen(screenName: "SigninSheet");
  showModalBottomSheet(
    context: context,
    builder: (_) => SigninSheet(),
    backgroundColor: Colors.transparent,
  );
}
