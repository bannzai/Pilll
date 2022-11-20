import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class OKDialog extends StatelessWidget {
  final String title;
  final String message;
  final Future<void> Function()? ok;

  const OKDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.ok,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(
        Icons.help,
        color: PilllColors.secondary,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title.isNotEmpty) ...[
            Text(title,
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ).merge(TextColorStyle.main)),
            const SizedBox(
              height: 15,
            ),
          ],
          Text(message,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ).merge(TextColorStyle.main)),
        ],
      ),
      actions: <Widget>[
        AlertButton(
          text: "OK",
          onPressed: () async {
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

Future<void> showOKDialog(
  BuildContext context, {
  required String title,
  required String message,
  Future<void> Function()? ok,
}) async {
  return showDialog(
    context: context,
    builder: (context) => OKDialog(
      title: title,
      message: message,
      ok: ok,
    ),
  );
}
