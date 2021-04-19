import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class DiscardDialog extends StatelessWidget {
  final String title;
  final String message;
  final String doneButtonText;
  final Function() done;
  final Function()? cancel;

  const DiscardDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.doneButtonText,
    required this.done,
    this.cancel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cancel = this.cancel;
    return AlertDialog(
      title: SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
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
          text: "キャンセル",
          onPressed: cancel != null
              ? () => cancel()
              : () {
                  Navigator.of(context).pop();
                },
        ),
        SecondaryButton(
          text: doneButtonText,
          onPressed: () {
            done();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
