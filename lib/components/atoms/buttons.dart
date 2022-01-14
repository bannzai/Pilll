import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 44, minHeight: 44, minWidth: 180),
      child: ElevatedButton(
        child: Text(text, style: ButtonTextStyle.main),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((statuses) {
          if (statuses.contains(MaterialState.disabled)) {
            return PilllColors.lightGray;
          }
          return PilllColors.secondary;
        })),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
        child: Text(text, style: TextColorStyle.primary),
        onPressed: onPressed,
      ),
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

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
  final Function() onPressed;

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

class SmallAppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SmallAppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Container(
        padding: EdgeInsets.only(top: 8.5, bottom: 8.5),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: TextColor.main,
              fontSize: 12,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: PilllColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: BorderSide(color: PilllColors.secondary),
      ),
      onPressed: onPressed,
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Container(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: TextColor.main,
              fontSize: 16,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: PilllColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: BorderSide(color: PilllColors.secondary),
      ),
      onPressed: onPressed,
    );
  }
}

class AlertButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AlertButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w600,
          fontSize: FontSize.normal,
          color: PilllColors.primary,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
