import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/util/datetime/day.dart';

class TakenButton extends StatelessWidget {
  final BuildContext context;
  final PillSheet pillSheet;
  final RecordPageStore store;

  const TakenButton({
    Key? key,
    required this.context,
    required this.pillSheet,
    required this.store,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
}
