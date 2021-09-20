import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_weekday_line.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';

class RecordPagePillSheet extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final RecordPageStore store;
  final RecordPageState state;

  List<PillSheetType> get pillSheetTypes =>
      pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const RecordPagePillSheet({
    Key? key,
    required this.pillSheetGroup,
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
          return PillMarkLine(
            pillMarks: _pillMarks(
              context,
              lineIndex: index,
              pageIndex: pillSheet.groupIndex,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _pillMarks(
    BuildContext context, {
    required int lineIndex,
    required int pageIndex,
  }) {
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length >
        pillSheet.pillSheetType.totalCount) {
      int diff = pillSheet.pillSheetType.totalCount -
          lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }
    return List.generate(Weekday.values.length, (columnIndex) {
      if (columnIndex >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }
      final pillNumberIntoPillSheet =
          PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(
              columnIndex, lineIndex);
      return Container(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          textOfPillNumber: _textOfPillNumber(
            state: state,
            pillSheetGroup: pillSheetGroup,
            pillNumberIntoPillSheet: pillNumberIntoPillSheet,
            pageIndex: pageIndex,
          ),
          pillMark: PillMark(
            hasRippleAnimation: store.shouldPillMarkAnimation(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
            ),
            isDone: store.isDone(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
            ),
            pillMarkType: store.markFor(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
            ),
          ),
          onTap: () {
            analytics.logEvent(name: "pill_mark_tapped", parameters: {
              "last_taken_pill_number": pillSheet.lastTakenPillNumber,
              "today_pill_number": pillSheet.todayPillNumber,
            });

            effectAfterTaken(
              context: context,
              taken: store.takenWithPillNumber(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheet: pillSheet,
              ),
              store: store,
            );
          },
        ),
      );
    });
  }

  Widget _textOfPillNumber({
    required RecordPageState state,
    required PillSheetGroup pillSheetGroup,
    required int pillNumberIntoPillSheet,
    required int pageIndex,
  }) {
    final date =
        pillSheet.beginingDate.add(Duration(days: pillNumberIntoPillSheet - 1));
    final isDateMode = () {
      if (!(state.isPremium || state.isTrial)) {
        return false;
      }
      if (state.appearanceMode != PillSheetAppearanceMode.date) {
        return false;
      }
      return true;
    }();

    final pillSheetTypes =
        pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final pastedCount =
        pastedTotalCount(pillSheetTypes: pillSheetTypes, pageIndex: pageIndex);
    final serializedPillNumberIntoGroup = pastedCount + pillNumberIntoPillSheet;
    final menstruationNumbers =
        List.generate(setting.durationMenstruation, (index) {
      return setting.pillNumberForFromMenstruation + index;
    });
    final isContainedMenstruationDuration =
        menstruationNumbers.contains(serializedPillNumberIntoGroup);

    if (isDateMode) {
      if (isContainedMenstruationDuration) {
        return MenstruationPillDate(date: date);
      } else {
        return PlainPillDate(date: date);
      }
    } else {
      if (isContainedMenstruationDuration) {
        return MenstruationPillNumber(pillNumber: pillNumberIntoPillSheet);
      } else {
        return PlainPillNumber(pillNumber: pillNumberIntoPillSheet);
      }
    }
  }
}
