import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

class EndManualRestDurationButton extends StatelessWidget {
  final RestDuration restDuration;
  final PillSheet activedPillSheet;
  final PillSheetGroup pillSheetGroup;
  final RecordPageStore store;
  final VoidCallback didEndRestDuration;

  const EndManualRestDurationButton({
    Key? key,
    required this.restDuration,
    required this.activedPillSheet,
    required this.pillSheetGroup,
    required this.store,
    required this.didEndRestDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: SmallAppOutlinedButton(
        text: "休薬終了",
        onPressed: () async {
          analytics.logEvent(
            name: "end_manual_rest_duration_pressed",
          );

          await store.endRestDuration(
            pillSheetGroup: pillSheetGroup,
            activedPillSheet: activedPillSheet,
            restDuration: restDuration,
          );

          didEndRestDuration();
        },
      ),
    );
  }
}

class EndRestDurationModal extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final RecordPageStore store;

  const EndRestDurationModal({
    Key? key,
    required this.pillSheetGroup,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastTakenPillNumber = pillSheetGroup.sequentialLastTakenPillNumber;
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: const Text(
          "休薬期間終了",
          style: TextStyle(
            color: TextColor.white,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "服用1日目から再開しますか？",
            style: TextStyle(
              color: TextColor.main,
              fontSize: 16,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "服用${lastTakenPillNumber + 1}日目→1日目",
            style: const TextStyle(
              color: TextColor.main,
              fontSize: 14,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          onPressed: () async {
            await store.setDisplayNumberSettingEnd(lastTakenPillNumber + 1);
          },
          text: "はい",
        ),
        AppOutlinedButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          text: "いいえ",
        ),
      ],
    );
  }
}
