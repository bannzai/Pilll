import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/dotted_line.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

class PillSheetModifiedHistoryEndedPillSheetAction extends StatelessWidget {
  final EndedPillSheetValue? value;
  const PillSheetModifiedHistoryEndedPillSheetAction({
    super.key,
    required this.value,
  });

  TextStyle get _textStyle => const TextStyle(
        color: TextColor.main,
        fontFamily: FontFamily.japanese,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width / 4 - 1,
          child: const DottedLine(),
        ),
        const SizedBox(width: 12),
        Text("ピルシート終了", style: _textStyle),
        const SizedBox(width: 12),
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width / 4 - 1,
          child: const DottedLine(),
        ),
      ],
    );
  }
}
