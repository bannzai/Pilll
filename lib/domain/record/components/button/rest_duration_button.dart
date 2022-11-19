import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';

class RestDurationButton extends StatelessWidget {
  const RestDurationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: PilllColors.disable),
        child: Text("休薬中", style: ButtonTextStyle.main.merge(TextColorStyle.lightGray)),
        onPressed: null,
      ),
    );
  }
}
