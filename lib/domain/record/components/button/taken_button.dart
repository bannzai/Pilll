import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/service/local_notification.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:timezone/timezone.dart' as tz;

class TakenButton extends HookConsumerWidget {
  final BuildContext parentContext;
  final PillSheet pillSheet;

  const TakenButton({
    Key? key,
    required this.parentContext,
    required this.pillSheet,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(recordPageStoreProvider.notifier);
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () async {
        analytics.logEvent(name: "taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        await localNotification.scheduleRemiderNotification(
          hour: 8,
          minute: 14,
          totalPillNumberOfPillSheetGroup: 1,
          tzFrom: tz.TZDateTime.now(tz.local),
          isTrialOrPremium: true,
        );
        // await effectAfterTakenPillAction(
        //   context: parentContext,
        //   taken: store.taken(),
        //   store: store,
        // );
      },
    );
  }
}
