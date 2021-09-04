import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/components/organisms/pill/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_view_weekday_line.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class RecordPagePillSheet extends StatelessWidget {
  final PillSheet pillSheet;
  final Setting setting;
  final RecordPageStore store;
  final RecordPageState state;

  const RecordPagePillSheet({
    Key? key,
    required this.pillSheet,
    required this.setting,
    required this.store,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillSheetViewLayout(
      weekdayLines: PillSheetViewWeekdayLine(
          firstWeekday:
              WeekdayFunctions.weekdayFromDate(pillSheet.beginingDate)),
      pillMarkLines: List.generate(
        pillSheet.pillSheetType.numberOfLineInPillSheet,
        (index) {
          return PillMarkLine(pillMarks: _pillMarks(context, index));
        },
      ),
    );
  }

  List<Widget> _pillMarks(BuildContext context, int index) {
    final lineNumber = index + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length >
        pillSheet.pillSheetType.totalCount) {
      int diff =
          pillSheet.pillSheetType.totalCount - index * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }
    return List.generate(Weekday.values.length, (index) {
      if (index >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }
      final number = index + 1;
      return Container(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          textOfPillNumber: _textOfPillNumber(state, number),
          pillMark: PillMark(
            hasRippleAnimation: store.shouldPillMarkAnimation(
                pillNumberIntoPillSheet: number, pillSheet: pillSheet),
            isDone: store.isDone(
                pillNumberIntoPillSheet: number, pillSheet: pillSheet),
            pillSheetType: store.markFor(
                pillNumberIntoPillSheet: number, pillSheet: pillSheet),
          ),
          onTap: () {
            analytics.logEvent(name: "pill_mark_tapped", parameters: {
              "number": number,
              "last_taken_pill_number": pillSheet.lastTakenPillNumber,
              "today_pill_number": pillSheet.todayPillNumber,
            });

            effectAfterTaken(
              context: context,
              taken: store.takenWithPillNumber(
                  pillNumberIntoPillSheet: number, pillSheet: pillSheet),
              store: store,
            );
          },
        ),
      );
    });
  }

  Text _textOfPillNumber(RecordPageState state, int pillNumber) {
    final date = pillSheet.beginingDate.add(Duration(days: pillNumber - 1));
    final isDateMode = () {
      if (!(state.isPremium || state.isTrial)) {
        return false;
      }
      if (state.appearanceMode != PillSheetAppearanceMode.date) {
        return false;
      }
      return true;
    }();

    return Text(
      isDateMode ? "$pillNumber" : DateTimeFormatter.monthAndDay(date),
      style: FontType.smallTitle.merge(
          PillMarkWithNumberLayoutHelper.upperTextColor(
              isPremium: state.isPremium,
              pillNumberForMenstruationBegin:
                  setting.pillNumberForFromMenstruation,
              menstruationDuration: setting.durationMenstruation,
              maxPillNumber: pillSheet.pillSheetType.totalCount,
              pillMarkNumber: pillNumber)),
    );
  }
}
