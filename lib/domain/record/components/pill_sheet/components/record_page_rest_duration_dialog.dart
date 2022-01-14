import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class RecordPageRestDurationDialog extends StatelessWidget {
  final VoidCallback onDone;

  const RecordPageRestDurationDialog({
    Key? key,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(left: 24, right: 24, top: 32),
      actionsPadding: EdgeInsets.only(left: 24, right: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("今日から休薬しますか？",
              style: FontType.subTitle.merge(TextColorStyle.main)),
          SizedBox(height: 24),
          Text("休薬するとピル番号は進みません",
              style: FontType.assisting.merge(TextColorStyle.main)),
          SizedBox(height: 24),
          SvgPicture.asset("images/explain_rest_duration.svg"),
          SizedBox(height: 24),
        ],
      ),
      actions: <Widget>[
        AppOutlinedButton(
          onPressed: () async => onDone(),
          text: "休薬する",
        ),
        Center(
          child: AlertButton(
            text: "閉じる",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

showRecordPageRestDurationDialog(BuildContext context, VoidCallback onDone) {
  showDialog(
    context: context,
    builder: (context) => RecordPageRestDurationDialog(
      onDone: onDone,
    ),
  );
}
