import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorAlert extends StatelessWidget {
  final String? title;
  final String errorMessage;
  final String? faqLinkURL;

  const ErrorAlert(
      {Key? key, this.title, this.faqLinkURL, required this.errorMessage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final faq = this.faqLinkURL;
    return AlertDialog(
      title: Text(
        title ?? "エラーが発生しました",
        style: FontType.subTitle.merge(TextColorStyle.black),
      ),
      content: Text(errorMessage,
          style: FontType.assisting.merge(TextColorStyle.black)),
      actions: <Widget>[
        if (faq != null)
          AlertButton(
            text: "FAQを見る",
            onPressed: () async {
              launch(faq);
            },
          ),
        AlertButton(
          text: "閉じる",
          onPressed: () async {
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

void showErrorAlertFor(BuildContext context, Object object) {
  showDialog(
    context: context,
    builder: (_) {
      return ErrorAlert(
        title: "エラーが発生しました",
        errorMessage: object.toString(),
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
        faqLinkURL: error.faqLinkURL,
      );
    },
  );
}
