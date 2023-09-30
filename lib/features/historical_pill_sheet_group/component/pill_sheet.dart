import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_weekday_line.dart';
import 'package:pilll/features/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

// ここを編集する時は record/component/record_page_pill_sheet.dart も編集する
class HistoricalPillsheetGroupPagePillSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;

  List<PillSheetType> get pillSheetTypes => pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const HistoricalPillsheetGroupPagePillSheet({
    Key? key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekdayDate =
        pillSheet.beginingDate.add(Duration(days: summarizedRestDuration(restDurations: pillSheet.restDurations, upperDate: today())));
    final takePill = ref.watch(takePillProvider);
    final revertTakePill = ref.watch(revertTakePillProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return PillSheetViewLayout(
      weekdayLines: PillSheetViewWeekdayLine(
        firstWeekday: WeekdayFunctions.weekdayFromDate(weekdayDate),
      ),
      pillMarkLines: List.generate(
        pillSheet.pillSheetType.numberOfLineInPillSheet,
        (index) {
          return PillMarkLine(
            pillMarks: _pillMarks(
              context,
              takePill: takePill,
              revertTakePill: revertTakePill,
              registerReminderLocalNotification: registerReminderLocalNotification,
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
    required TakePill takePill,
    required RevertTakePill revertTakePill,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
    required int lineIndex,
    required int pageIndex,
  }) {
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length > pillSheet.pillSheetType.totalCount) {
      int diff = pillSheet.pillSheetType.totalCount - lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }

    return List.generate(Weekday.values.length, (columnIndex) {
      if (columnIndex >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }

      final pillNumberInPillSheet = PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(columnIndex, lineIndex);
      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          pillNumber: PillNumber(
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            setting: setting,
            pillNumberInPillSheet: pillNumberInPillSheet,
            pageIndex: pageIndex,
          ),
          pillMark: PillMark(
            showsRippleAnimation: shouldPillMarkAnimation(
              pillNumberInPillSheet: pillNumberInPillSheet,
              pillSheet: pillSheet,
              pillSheetGroup: pillSheetGroup,
            ),
            showsCheckmark: _isDone(
              pillNumberInPillSheet: pillNumberInPillSheet,
            ),
            pillMarkType: pillMarkFor(
              pillNumberInPillSheet: pillNumberInPillSheet,
              pillSheet: pillSheet,
            ),
          ),
          onTap: () {},
        ),
      );
    });
  }

  bool _isDone({
    required int pillNumberInPillSheet,
  }) {
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw const FormatException("pill sheet not found");
    }
    if (activePillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activePillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        if (pillNumberInPillSheet > pillSheet.lastTakenPillNumber) {
          return false;
        }
      }
      return true;
    }

    return pillNumberInPillSheet <= activePillSheet.lastTakenPillNumber;
  }
}

PillMarkType pillMarkFor({
  required int pillNumberInPillSheet,
  required PillSheet pillSheet,
}) {
  if (pillNumberInPillSheet > pillSheet.typeInfo.dosingPeriod) {
    return (pillSheet.pillSheetType == PillSheetType.pillsheet_21 || pillSheet.pillSheetType == PillSheetType.pillsheet_24_rest_4)
        ? PillMarkType.rest
        : PillMarkType.fake;
  }
  if (pillNumberInPillSheet <= pillSheet.lastTakenPillNumber) {
    return PillMarkType.done;
  }
  if (pillNumberInPillSheet < pillSheet.todayPillNumber) {
    return PillMarkType.normal;
  }
  return PillMarkType.normal;
}

bool shouldPillMarkAnimation({
  required int pillNumberInPillSheet,
  required PillSheet pillSheet,
  required PillSheetGroup pillSheetGroup,
}) {
  if (pillSheetGroup.activePillSheet?.activeRestDuration != null) {
    return false;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    throw const FormatException("pill sheet not found");
  }
  if (activePillSheet.groupIndex < pillSheet.groupIndex) {
    return false;
  }
  if (activePillSheet.id != pillSheet.id) {
    if (pillSheet.isBegan) {
      if (pillNumberInPillSheet > pillSheet.lastTakenPillNumber) {
        return true;
      }
    }
    return false;
  }

  return pillNumberInPillSheet > activePillSheet.lastTakenPillNumber && pillNumberInPillSheet <= activePillSheet.todayPillNumber;
}

class PillNumber extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final int pageIndex;
  final int pillNumberInPillSheet;

  const PillNumber(
      {super.key,
      required this.pillSheetGroup,
      required this.pillSheet,
      required this.setting,
      required this.pageIndex,
      required this.pillNumberInPillSheet});

  @override
  Widget build(BuildContext context) {
    final menstruationDateRanges = pillSheetGroup.menstruationDateRanges(setting: setting);

    final containedMenstruationDuration =
        menstruationDateRanges.where((e) => e.inRange(pillSheet.displayPillTakeDate(pillNumberInPillSheet))).isNotEmpty;

    final text = pillSheetGroup.displayPillNumber(
      premiumOrTrial: true,
      pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
      pageIndex: pageIndex,
      pillNumberInPillSheet: pillNumberInPillSheet,
    );

    if (containedMenstruationDuration) {
      return MenstruationPillNumber(text: text);
    } else {
      return PlainPillNumber(text: text);
    }
  }
}
