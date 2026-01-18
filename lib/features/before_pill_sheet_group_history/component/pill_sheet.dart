import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_weekday_line.dart';
import 'package:pilll/features/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet.dart' show remainingPillTakenCountFor;
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

// ここを編集する時は record/component/record_page_pill_sheet.dart も編集する
class HistoricalPillsheetGroupPagePillSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;

  List<PillSheetType> get pillSheetTypes => pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const HistoricalPillsheetGroupPagePillSheet({super.key, required this.pillSheetGroup, required this.pillSheet, required this.setting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekdayDate = pillSheet.beginDate.addDays(summarizedRestDuration(restDurations: pillSheet.restDurations, upperDate: today()));
    final takePill = ref.watch(takePillProvider);
    final revertTakePill = ref.watch(revertTakePillProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return PillSheetViewLayout(
      weekdayLines: PillSheetViewWeekdayLine(firstWeekday: WeekdayFunctions.weekdayFromDate(weekdayDate)),
      pillMarkLines: List.generate(pillSheet.pillSheetType.numberOfLineInPillSheet, (index) {
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
      }),
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
            showsRippleAnimation: false,
            showsCheckmark: _isDone(pillNumberInPillSheet: pillNumberInPillSheet),
            pillMarkType: pillMarkFor(pillNumberInPillSheet: pillNumberInPillSheet, pillSheet: pillSheet),
            remainingPillTakenCount: remainingPillTakenCountFor(pillNumberInPillSheet: pillNumberInPillSheet, pillSheet: pillSheet),
          ),
          onTap: () {},
        ),
      );
    });
  }

  bool _isDone({required int pillNumberInPillSheet}) {
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw const FormatException('pill sheet not found');
    }
    if (activePillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activePillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        // v2の場合はlastCompletedPillNumberで判定
        final lastCompleted = switch (pillSheet) {
          PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
          PillSheetV2 v2 => v2.lastCompletedPillNumber,
        };
        if (pillNumberInPillSheet > lastCompleted) {
          return false;
        }
      }
      return true;
    }

    return switch (activePillSheet) {
      PillSheetV1() => pillNumberInPillSheet <= activePillSheet.lastTakenOrZeroPillNumber,
      PillSheetV2 v2 => pillNumberInPillSheet <= v2.lastCompletedPillNumber,
    };
  }
}

PillMarkType pillMarkFor({required int pillNumberInPillSheet, required PillSheet pillSheet}) {
  if (pillNumberInPillSheet > pillSheet.typeInfo.dosingPeriod) {
    return (pillSheet.pillSheetType == PillSheetType.pillsheet_21 || pillSheet.pillSheetType == PillSheetType.pillsheet_24_rest_4)
        ? PillMarkType.rest
        : PillMarkType.fake;
  }
  // v2の場合はlastCompletedPillNumberで判定
  final lastCompleted = switch (pillSheet) {
    PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
    PillSheetV2 v2 => v2.lastCompletedPillNumber,
  };
  if (pillNumberInPillSheet <= lastCompleted) {
    return PillMarkType.done;
  }
  if (pillNumberInPillSheet < pillSheet.todayPillNumber) {
    return PillMarkType.normal;
  }
  return PillMarkType.normal;
}

bool shouldPillMarkAnimation({required int pillNumberInPillSheet, required PillSheet pillSheet, required PillSheetGroup pillSheetGroup}) {
  if (pillSheetGroup.lastActiveRestDuration != null) {
    return false;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    throw const FormatException('pill sheet not found');
  }
  if (activePillSheet.groupIndex < pillSheet.groupIndex) {
    return false;
  }
  if (activePillSheet.id != pillSheet.id) {
    if (pillSheet.isBegan) {
      // v2の場合はlastCompletedPillNumberで判定
      final lastCompleted = switch (pillSheet) {
        PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
        PillSheetV2 v2 => v2.lastCompletedPillNumber,
      };
      if (pillNumberInPillSheet > lastCompleted) {
        return true;
      }
    }
    return false;
  }

  // v2の場合はlastCompletedPillNumberで判定
  final lastCompleted = switch (activePillSheet) {
    PillSheetV1() => activePillSheet.lastTakenOrZeroPillNumber,
    PillSheetV2 v2 => v2.lastCompletedPillNumber,
  };
  return pillNumberInPillSheet > lastCompleted && pillNumberInPillSheet <= activePillSheet.todayPillNumber;
}

class PillNumber extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final int pageIndex;
  final int pillNumberInPillSheet;

  const PillNumber({
    super.key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.setting,
    required this.pageIndex,
    required this.pillNumberInPillSheet,
  });

  @override
  Widget build(BuildContext context) {
    final menstruationDateRanges = pillSheetGroup.menstruationDateRanges(setting: setting);

    final containedMenstruationDuration = menstruationDateRanges
        .where((e) => e.inRange(pillSheet.displayPillTakeDate(pillNumberInPillSheet)))
        .isNotEmpty;

    final text = pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);

    if (containedMenstruationDuration) {
      return MenstruationPillNumber(text: text);
    } else {
      return PlainPillNumber(text: text);
    }
  }
}
