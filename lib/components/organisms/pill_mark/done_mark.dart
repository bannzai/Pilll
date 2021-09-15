import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class PillMarkDoneMark extends StatelessWidget {
  const PillMarkDoneMark({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "images/checkmark.svg",
      color: PilllColors.potti,
      width: 11,
      height: 8.5,
    );
  }
}
