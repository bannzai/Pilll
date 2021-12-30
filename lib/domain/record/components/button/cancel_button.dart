import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';

class CancelButton extends HookConsumerWidget {
  final PillSheet pillSheet;

  CancelButton(this.pillSheet);
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(recordPageStoreProvider.notifier);
    return TertiaryButton(
      text: "飲んでない",
      onPressed: () {
        analytics.logEvent(name: "cancel_taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        _cancelTake(pillSheet, store);
      },
    );
  }

  void _cancelTake(PillSheet pillSheet, RecordPageStore store) {
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      return;
    }
    final lastTakenDate = pillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      return;
    }
    store.cancelTaken();
  }
}
