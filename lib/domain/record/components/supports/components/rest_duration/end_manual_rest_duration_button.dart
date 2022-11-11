import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';

class EndManualRestDurationButton extends HookConsumerWidget {
  final RestDuration restDuration;
  final PillSheet activedPillSheet;
  final PillSheetGroup pillSheetGroup;
  final VoidCallback didEndRestDuration;

  const EndManualRestDurationButton({
    Key? key,
    required this.restDuration,
    required this.activedPillSheet,
    required this.pillSheetGroup,
    required this.didEndRestDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchFactory = ref.watch(batchFactoryProvider);
    final batchSetPillSheets = ref.watch(batchSetPillSheetsProvider);
    final batchSetPillSheetGroup = ref.watch(batchSetPillSheetGroupProvider);
    final batchSetPillSheetModifiedHistory = ref.watch(batchSetPillSheetModifiedHistoryProvider);
    return SizedBox(
      width: 80,
      child: SmallAppOutlinedButton(
        text: "休薬終了",
        onPressed: () async {
          analytics.logEvent(
            name: "end_manual_rest_duration_pressed",
          );

          await _endRestDuration(
            batchFactory,
            batchSetPillSheets: batchSetPillSheets,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          );

          didEndRestDuration();
        },
      ),
    );
  }

  Future<void> _endRestDuration(
    BatchFactory batchFactory, {
    required BatchSetPillSheets batchSetPillSheets,
    required BatchSetPillSheetGroup batchSetPillSheetGroup,
    required BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory,
  }) async {
    final batch = batchFactory.batch();
    final updatedRestDuration = restDuration.copyWith(endDate: now());
    final updatedPillSheet = activedPillSheet.copyWith(
      restDurations: activedPillSheet.restDurations
        ..replaceRange(
          activedPillSheet.restDurations.length - 1,
          activedPillSheet.restDurations.length,
          [updatedRestDuration],
        ),
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    batchSetPillSheets(batch, updatedPillSheetGroup.pillSheets);
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activedPillSheet,
        after: updatedPillSheet,
        restDuration: updatedRestDuration,
      ),
    );
    await batch.commit();
  }
}

class EndRestDurationModal extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;

  const EndRestDurationModal({
    Key? key,
    required this.pillSheetGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastTakenPillNumber = pillSheetGroup.sequentialLastTakenPillNumber;
    final setPillSheetGroup = ref.watch(setPillSheetGroupProvider);
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
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
                      analytics.logEvent(name: "display_number_setting_modal_no");
                      Navigator.of(context).pop();
                    },
                    text: "いいえ",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppOutlinedButton(
                    onPressed: () async {
                      analytics.logEvent(name: "display_number_setting_modal_yes");
                      await _setDisplayNumberSettingEndNumber(setPillSheetGroup, end: lastTakenPillNumber, pillSheetGroup: pillSheetGroup);
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

  Future<void> _setDisplayNumberSettingEndNumber(
    SetPillSheetGroup setPillSheetGroup, {
    required int end,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final offsetPillNumber = pillSheetGroup.displayNumberSetting;
    final PillSheetGroup updatedPillSheetGroup;
    if (offsetPillNumber == null) {
      final newDisplayNumberSetting = DisplayNumberSetting(endPillNumber: end);
      updatedPillSheetGroup = pillSheetGroup.copyWith(displayNumberSetting: newDisplayNumberSetting);
    } else {
      final newDisplayNumberSetting = offsetPillNumber.copyWith(endPillNumber: end);
      updatedPillSheetGroup = pillSheetGroup.copyWith(displayNumberSetting: newDisplayNumberSetting);
    }
    await setPillSheetGroup(updatedPillSheetGroup);
  }
}

void showEndRestDurationModal(
  BuildContext context, {
  required PillSheetGroup pillSheetGroup,
}) {
  showDialog(
    context: context,
    builder: (context) => EndRestDurationModal(
      pillSheetGroup: pillSheetGroup,
    ),
  );
}
