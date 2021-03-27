import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleAlert extends StatelessWidget {
  final String title;
  final String message;
  final String? doneText;
  final String? cancelText;
  final VoidCallback done;
  final VoidCallback? cancel;

  const SimpleAlert({
    Key? key,
    required this.title,
    required this.message,
    this.doneText,
    this.cancelText,
    required this.done,
    this.cancel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: FontType.subTitle.merge(TextColorStyle.black),
      ),
      content:
          Text(message, style: FontType.assisting.merge(TextColorStyle.black)),
      actions: <Widget>[
        SecondaryButton(
          text: doneText ?? "OK",
          onPressed: () => done(),
        ),
        SecondaryButton(
          text: cancelText ?? "キャンセル",
          onPressed: () {
            if (cancel != null) {
              cancel!();
              return;
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showSimpleAlert(
  BuildContext context, {
  required String title,
  required String message,
  String? doneText,
  String? cancelText,
  required VoidCallback done,
  VoidCallback? cancel,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return SimpleAlert(
        title: title,
        message: message,
        doneText: doneText,
        cancelText: cancelText,
        done: done,
        cancel: cancel,
      );
    },
  );
}
