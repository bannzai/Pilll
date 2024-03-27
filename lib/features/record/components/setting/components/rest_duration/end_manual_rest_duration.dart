import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/utils/local_notification.dart';

class EndManualRestDuration extends HookConsumerWidget {
  final RestDuration restDuration;
  final PillSheet activePillSheet;
  final PillSheetGroup pillSheetGroup;
  final Setting setting;

  const EndManualRestDuration({
    Key? key,
    required this.restDuration,
    required this.activePillSheet,
    required this.pillSheetGroup,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endRestDuration = ref.watch(endRestDurationProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    void didEndRestDuration(PillSheetGroup endedRestDurationPillSheetGroup) {
      if (endedRestDurationPillSheetGroup.sequentialLastTakenPillNumber > 0 &&
          setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) {
        showEndRestDurationModal(
          context,
          endedRestDurationPillSheetGroup: endedRestDurationPillSheetGroup,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(
              seconds: 2,
            ),
            content: Text("服用のお休み期間が終了しました"),
          ),
        );
      }
    }

    return ListTile(
      leading: const Icon(Icons.stop_circle, color: PilllColors.primary),
      title: const Text(
        "服用再開",
      ),
      onTap: () async {
        analytics.logEvent(name: "end_manual_rest_duration_pressed");

        try {
          final endedRestDurationPillSheetGroup = await endRestDuration(
            restDuration: restDuration,
            activePillSheet: activePillSheet,
            pillSheetGroup: pillSheetGroup,
          );
          await registerReminderLocalNotification();
          didEndRestDuration(endedRestDurationPillSheetGroup);
        } catch (e) {
          debugPrint("endRestDuration error: $e");
        }
      },
    );
  }
}

class EndRestDurationModal extends HookConsumerWidget {
  final PillSheetGroup endedRestDurationPillSheetGroup;

  const EndRestDurationModal({
    Key? key,
    required this.endedRestDurationPillSheetGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastTakenPillNumber = endedRestDurationPillSheetGroup.sequentialLastTakenPillNumber;
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
                  "服用${lastTakenPillNumber + 1}番→1番",
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
                      await _setDisplayNumberSettingEndNumber(setPillSheetGroup,
                          end: lastTakenPillNumber, pillSheetGroup: endedRestDurationPillSheetGroup);
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
  required PillSheetGroup endedRestDurationPillSheetGroup,
}) {
  showDialog(
    context: context,
    builder: (context) => EndRestDurationModal(
      endedRestDurationPillSheetGroup: endedRestDurationPillSheetGroup,
    ),
  );
}
