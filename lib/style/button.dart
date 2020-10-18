import 'package:Pilll/theme/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const PrimaryButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: RaisedButton(
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const SecondaryButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text, style: ButtonTextStyle.alert),
      onPressed: onPressed,
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const TertiaryButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: FlatButton(
        color: HexColor.fromHex("BEC0C2"),
        textColor: TextColor.white,
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
