import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/util/datetime/day.dart';

class RecordPageButton extends HookWidget {
  final PillSheet currentPillSheet;

  const RecordPageButton({
    Key? key,
    required this.currentPillSheet,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final store = useProvider(recordPageStoreProvider);
    if (currentPillSheet.allTaken)
      return _cancelTakeButton(currentPillSheet, store);
    else
      return _takenButton(context, currentPillSheet, store);
  }

  Widget _takenButton(
    BuildContext context,
    PillSheet pillSheet,
    RecordPageStore store,
  ) {
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () async {
        if (pillSheet.todayPillNumber == 1)
          analytics.logEvent(name: "user_taken_first_day_pill");
        analytics.logEvent(name: "taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        await take(context, pillSheet, now(), store);
      },
    );
  }

  Widget _cancelTakeButton(PillSheet pillSheet, RecordPageStore store) {
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
    store.take(lastTakenDate.subtract(Duration(days: 1)));
  }
}
