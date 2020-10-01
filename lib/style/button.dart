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
        textColor: TextColor.gray,
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
