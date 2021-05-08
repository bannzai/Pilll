import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Column(
          children: [
            SvgPicture.asset("assets/draggable_bar.svg", height: 6),
            Text("アカウント登録"),
            Text("アカウント登録すると\nデータの引き継ぎが可能になります"),
            SignInWithAppleButton(onPressed: () {}),
            _googleButton(),
            SecondaryButton(onPressed: () {}, text: "ログイン")
          ],
        );
      },
    );
  }

  Widget _googleButton() {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () async {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset("assets/google_icon.svg", height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Google アカウントで登録',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
