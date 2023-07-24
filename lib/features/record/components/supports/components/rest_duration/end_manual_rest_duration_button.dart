import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/record/components/supports/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/utils/local_notification.dart';

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
    final endRestDuration = ref.watch(endRestDurationProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    return SmallAppOutlinedButton(
      text: "服用再開",
      onPressed: () async {
        analytics.logEvent(
          name: "end_manual_rest_duration_pressed",
        );

        await endRestDuration(
          restDuration: restDuration,
          activePillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
        );
        await registerReminderLocalNotification.call();

        didEndRestDuration();
      },
    );
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
    final lastCompletedPillNumber = pillSheetGroup.sequentialLastTakenPillNumber;
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
                color: PilllColors.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                "服用お休み期間終了",
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
                  "服用${lastCompletedPillNumber + 1}番→1番",
                  style: const TextStyle(
                    color: TextColor.main,
                    fontSize: 14,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  "お休みした分だけシート上の曜日もずれます",
                  style: TextStyle(
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
                      final navigator = Navigator.of(context);
                      await _setDisplayNumberSettingEndNumber(setPillSheetGroup, end: lastCompletedPillNumber, pillSheetGroup: pillSheetGroup);
                      navigator.pop();
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
      final newDisplayNumberSetting = PillSheetGroupDisplayNumberSetting(endPillNumber: end);
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
