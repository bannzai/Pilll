import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PillSheetAppearanceModeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _number(),
      _number(),
      _number(),
    ]);
  }

  Widget _number() {
    return SvgPicture.asset("images/number_appearance_mode_switch.svg");
  }
}
