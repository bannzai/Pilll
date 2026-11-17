import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorAlert extends StatelessWidget {
  final String? title;
  final String errorMessage;
  final String? faqLinkURL;

  const ErrorAlert({
    super.key,
    this.title,
    this.faqLinkURL,
    required this.errorMessage,
  });
  @override
  Widget build(BuildContext context) {
    final faq = faqLinkURL;
    return AlertDialog(
      title: Text(
        title ?? L.errorOccurred,
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: TextColor.black,
        ),
      ),
      // 手順を案内する長い本文が画面の高さを超えても、末尾まで読めるようにスクロールさせる。
      // 本文が行の切れ目で終わって見えると続きがあることに気づけないため、スクロールバーを常に出す。
      // primary: true は、Scrollbar と本文が同じ ScrollController (ダイアログの route の PrimaryScrollController) を使うため
      // RawScrollbar を使うのは、Material の Scrollbar が iOS で使う CupertinoScrollbar には crossAxisMargin が無いため
      content: RawScrollbar(
        thumbVisibility: true,
        thumbColor: TextColor.black.withValues(alpha: 0.3),
        thickness: 4,
        radius: const Radius.circular(2),
        // 本文の幅を変えずに文字とも重ならないよう、スクロールバーを本文の外側 (AlertDialog の content の左右の余白 24 の中) に描く。
        // 負の値は本文の端から外へ出す距離で、スクロールバーが出る側 (文字方向の終わり側) に効く
        crossAxisMargin: -12,
        child: SingleChildScrollView(
          primary: true,
          child: Text(
            errorMessage,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: TextColor.black,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        if (faq != null)
          AlertButton(
            text: L.seeFAQ,
            onPressed: () async {
              launchUrl(Uri.parse(faq));
            },
          ),
        AlertButton(
          text: L.close,
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showErrorAlert(BuildContext? context, Object error) {
  if (context == null) {
    return;
  }
  final String title;
  final String message;
  final String? faqLinkURL;
  if (error is FormatException) {
    title = L.unknownError;
    message = error.message;
    faqLinkURL = null;
  } else if (error is AlertError) {
    title = error.title ?? L.errorOccurred;
    message = error.displayedMessage;
    faqLinkURL = error.faqLinkURL;
  } else if (error is String) {
    title = L.errorOccurred;
    message = error;
    faqLinkURL = null;
  } else {
    title = L.unexpectedErrorOccurred;
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
