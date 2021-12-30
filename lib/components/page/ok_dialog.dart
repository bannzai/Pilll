import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class OKDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? ok;

  const OKDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.ok,
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
        AlertButton(
          text: "OK",
          onPressed: () {
            final ok = this.ok;
            if (ok != null) {
              ok();
            } else {
              Navigator.of(context).pop();
            }
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
  VoidCallback? ok,
}) {
  showDialog(
    context: context,
    builder: (context) => OKDialog(
      title: title,
      message: message,
      ok: ok,
    ),
  );
}
