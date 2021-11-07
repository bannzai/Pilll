import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/record_page_store.dart';

class SwitchingAppearanceMode extends StatelessWidget {
  final RecordPageStore store;
  const SwitchingAppearanceMode({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(children: [
        SvgPicture.asset("images/switching_appearance_mode.svg"),
        Text(
          "表示モード",
          style: TextStyle(
            color: TextColor.main,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
      ]),
      onTap: () {
        // TODO:
      },
    );
  }
}
