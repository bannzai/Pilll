import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/error/alert_error.dart';
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
    final faq = faqLinkURL;
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
              launchUrl(Uri.parse(faq));
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

void showErrorAlert(BuildContext context, Object error) {
  final String title;
  final String message;
  final String? faqLinkURL;
  if (error is FormatException) {
    title = "不明なエラーが発生しました";
    message = error.message;
    faqLinkURL = null;
  } else if (error is AlertError) {
    title = error.title ?? "エラーが発生しました";
    message = error.displayedMessage;
    faqLinkURL = error.faqLinkURL;
  } else if (error is String) {
    title = "エラーが発生しました";
    message = error;
    faqLinkURL = null;
  } else {
    title = "予想外のエラーが発生しました";
    message = error.toString();
    faqLinkURL = null;
  }
  showDialog(
    context: context,
    builder: (_) {
      return ErrorAlert(
        title: title,
        errorMessage: message,
        faqLinkURL: faqLinkURL,
      );
    },
  );
}
