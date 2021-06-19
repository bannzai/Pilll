import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:url_launcher/url_launcher.dart';

class WrappedErrorAlert extends StatefulWidget {
  final Widget child;

  const WrappedErrorAlert({Key? key, required this.child}) : super(key: key);
  @override
  _WrappedErrorAlertState createState() => _WrappedErrorAlertState();
}

class _WrappedErrorAlertState extends State<WrappedErrorAlert> {
  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Visibility(
          visible: visible,
          child: GestureDetector(
            onTap: () {
              setState(() {
                visible = !visible;
              });
            },
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.08),
              dismissible: true,
              barrierSemanticsDismissible: true,
            ),
          ),
        ),
        ErrorAlert(
          errorMessage: "Test",
        ),
      ],
    );
  }
}

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
          SecondaryButton(
            text: "FAQを見る",
            onPressed: () {
              launch(faq);
            },
          ),
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
        faqLinkURL: error.faqLinkURL,
      );
    },
  );
}
