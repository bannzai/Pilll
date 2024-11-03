import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/local_notification.dart';

class EndManualRestDuration extends HookConsumerWidget {
  final RestDuration restDuration;
  final PillSheet activePillSheet;
  final PillSheetGroup pillSheetGroup;
  final Setting setting;

  const EndManualRestDuration({
    super.key,
    required this.restDuration,
    required this.activePillSheet,
    required this.pillSheetGroup,
    required this.setting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endRestDuration = ref.watch(endRestDurationProvider);
    final registerReminderLocalNotification =
        ref.watch(registerReminderLocalNotificationProvider);

    void didEndRestDuration(PillSheetGroup endedRestDurationPillSheetGroup) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(
            seconds: 2,
          ),
          content: Text('服用のお休み期間が終了しました'),
        ),
      );
    }

    return ListTile(
      leading: const Icon(Icons.play_arrow),
      title: const Text(
        '服用再開',
      ),
      onTap: () async {
        analytics.logEvent(name: 'end_manual_rest_duration_pressed');

        try {
          final endedRestDurationPillSheetGroup = await endRestDuration(
            restDuration: restDuration,
            activePillSheet: activePillSheet,
            pillSheetGroup: pillSheetGroup,
          );
          await registerReminderLocalNotification();
          didEndRestDuration(endedRestDurationPillSheetGroup);
        } catch (e) {
          debugPrint('endRestDuration error: $e');
        }
      },
    );
  }
}
