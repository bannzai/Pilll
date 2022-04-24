import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
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
    return Center(
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
        decoration: BoxDecoration(
          color: PilllColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                color: PilllColors.secondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                "休薬期間終了",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TextColor.white,
                  fontSize: 12,
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "服用1番目から再開しますか？",
                  style: TextStyle(
                    color: TextColor.main,
                    fontSize: 16,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "服用${lastTakenPillNumber + 1}番→1番",
                  style: const TextStyle(
                    color: TextColor.main,
                    fontSize: 14,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    onPressed: () async {
                      analytics.logEvent(
                          name: "display_number_setting_modal_no");
                      Navigator.of(context).pop();
                    },
                    text: "いいえ",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppOutlinedButton(
                    onPressed: () async {
                      analytics.logEvent(
                          name: "display_number_setting_modal_yes");
                      await store.setDisplayNumberSettingEndNumber(
                          lastTakenPillNumber);
                      Navigator.of(context).pop();
                    },
                    text: "はい",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showEndRestDurationModal(
  BuildContext context, {
  required PillSheetGroup pillSheetGroup,
  required RecordPageStore store,
  required PillSheet activedPillSheet,
}) {
  if (activedPillSheet.lastTakenPillNumber <= 0) {
    return;
  }
  showDialog(
    context: context,
    builder: (context) => EndRestDurationModal(
      pillSheetGroup: pillSheetGroup,
      store: store,
    ),
  );
}
