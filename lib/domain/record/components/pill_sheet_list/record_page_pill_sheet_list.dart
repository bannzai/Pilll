import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/components/organisms/pill/pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordPagePillSheetList extends StatelessWidget {
  const RecordPagePillSheetList({
    Key? key,
    required this.state,
    required this.store,
    required this.setting,
  }) : super(key: key);

  final RecordPageState state;
  final RecordPageStore store;
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return PillSheetView(
      firstWeekday:
          WeekdayFunctions.weekdayFromDate(pillSheetGroup.beginingDate),
      pillSheetType: pillSheetGroup.pillSheetType,
      doneStateBuilder: (number) {
        return number <= pillSheetGroup.lastTakenPillNumber;
      },
      pillMarkTypeBuilder: (number) => store.markFor(number),
      enabledMarkAnimation: (number) => store.shouldPillMarkAnimation(number),
      markSelected: (number) {
        analytics.logEvent(name: "pill_mark_tapped", parameters: {
          "number": number,
          "last_taken_pill_number": pillSheetGroup.lastTakenPillNumber,
          "today_pill_number": pillSheetGroup.todayPillNumber,
        });

//        effectAfterTaken(
//            context: context,
//            taken: store.takenWithPillNumber(number),
//            store: store);
      },
      premiumMarkBuilder: () {
        if (!(state.isPremium || state.isTrial)) {
          return null;
        }
        if (state.appearanceMode != PillSheetAppearanceMode.date) {
          return null;
        }
        final pillSheet = state.pillSheetGroup?.activedPillSheet;
        if (pillSheet == null) {
          return null;
        }
        return (pillMarkNumber) {
          final date =
              pillSheet.beginingDate.add(Duration(days: pillMarkNumber - 1));
          return PremiumPillMarkModel(
            date: date,
            pillNumberForMenstruationBegin:
                setting.pillNumberForFromMenstruation,
            menstruationDuration: setting.durationMenstruation,
            maxPillNumber: pillSheet.pillSheetType.totalCount,
          );
        };
      }(),
    );
  }
}
