import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class OKDialog extends StatelessWidget {
  final String title;
  final String message;

  const OKDialog({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(
        Icons.help,
        color: PilllColors.secondary,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title.isNotEmpty) ...[
            Text(title, style: FontType.subTitle.merge(TextColorStyle.main)),
            SizedBox(
              height: 15,
            ),
          ],
          Text(message, style: FontType.assisting.merge(TextColorStyle.main)),
        ],
      ),
      actions: <Widget>[
        SecondaryButton(
          text: "OK",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

showOKDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) => OKDialog(
      title: title,
      message: message,
    ),
  );
}
