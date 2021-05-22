import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/entity/user_error.dart';

class ErrorAlert extends StatelessWidget {
  final String? title;
  final String errorMessage;

  const ErrorAlert({Key? key, this.title, required this.errorMessage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ?? "エラーが発生しました",
        style: FontType.subTitle.merge(TextColorStyle.black),
      ),
      content: Text(errorMessage,
          style: FontType.assisting.merge(TextColorStyle.black)),
      actions: <Widget>[
        SecondaryButton(
          text: "閉じる",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showErrorAlert(BuildContext context,
    {String? title, required String message}) {
  showDialog(
    context: context,
    builder: (_) {
      return ErrorAlert(
        title: title,
        errorMessage: message,
      );
    },
  );
}

void showErrorAlertWithError(BuildContext context, UserDisplayedError error) {
  showDialog(
    context: context,
    builder: (_) {
      return ErrorAlert(
        title: error.title ?? "エラーが発生しました",
        errorMessage: error.toString(),
      );
    },
  );
}
