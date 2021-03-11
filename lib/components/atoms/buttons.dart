import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: ElevatedButton(
        child: Text(text, style: ButtonTextStyle.main),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text, style: ButtonTextStyle.alert),
      onPressed: onPressed,
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const TertiaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: PilllColors.gray),
        child:
            Text(text, style: ButtonTextStyle.main.merge(TextColorStyle.white)),
        onPressed: onPressed,
      ),
    );
  }
}

class InconspicuousButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const InconspicuousButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
        child: Text(text, style: TextColorStyle.gray),
        onPressed: onPressed,
      ),
    );
  }
}
