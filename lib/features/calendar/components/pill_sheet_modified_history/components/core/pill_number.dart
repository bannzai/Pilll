import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class PillNumber extends StatelessWidget {
  const PillNumber({
    Key? key,
    required this.pillNumber,
  }) : super(key: key);

  final String pillNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      pillNumber,
      style: const TextStyle(
        color: TextColor.main,
        fontFamily: FontFamily.japanese,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }
}

abstract class PillSheetModifiedHistoryPillNumberOrDate {
  static String hyphen() => "-";
  static String taken({required int beforeLastTakenPillNumber, required int afterLastTakenPillNumber}) {
    // beforePillSheetの最後に飲んだ番号+1から服用記録が始まる
    final left = beforeLastTakenPillNumber + 1;
    // 1度飲みの時に本日分を服用した場合は1錠分の服用履歴を表示する
    if (left == afterLastTakenPillNumber) {
      return "$afterLastTakenPillNumber番";
    }
    return "$left-$afterLastTakenPillNumber番";
  }

  static String autoTaken({required int beforeLastTakenPillNumber, required int afterLastTakenPillNumber}) {
    // beforePillSheetの最後に飲んだ番号+1から服用記録が始まる
    final left = beforeLastTakenPillNumber + 1;
    if (left == afterLastTakenPillNumber) {
      return "$afterLastTakenPillNumber番";
    }
    return "$left-$afterLastTakenPillNumber番";
  }

  static String revert({required int beforeLastTakenPillNumber, required int afterLastTakenPillNumber}) {
    if (beforeLastTakenPillNumber == (afterLastTakenPillNumber + 1)) {
      return "$beforeLastTakenPillNumber番";
    }
    return "$beforeLastTakenPillNumber-${afterLastTakenPillNumber + 1}番";
  }

  static String changedPillNumber({required int beforeTodayPillNumber, required int afterTodayPillNumber}) =>
      "$beforeTodayPillNumber→$afterTodayPillNumber番";

  static String changedBeginDisplayNumberSetting(ChangedBeginDisplayNumberValue value) {
    final before = value.beforeDisplayNumberSetting;
    if (before == null || before.beginPillNumber == null) {
      return "1→${value.afterDisplayNumberSetting.beginPillNumber}番";
    }
    return "${before.beginPillNumber}→${value.afterDisplayNumberSetting.beginPillNumber}番";
  }

  static String changedEndDisplayNumberSetting(ChangedEndDisplayNumberValue value) {
    final before = value.beforeDisplayNumberSetting;
    if (before == null || before.endPillNumber == null) {
      return "1→${value.afterDisplayNumberSetting.endPillNumber}番";
    }
    return "${before.endPillNumber}→${value.afterDisplayNumberSetting.endPillNumber}番";
  }

  static String pillSheetCount(List<String> pillSheetIDs) => pillSheetIDs.isNotEmpty ? "${pillSheetIDs.length}枚" : hyphen();

  static String changedRestDuration(ChangedRestDurationValue value) {
    final before = value.beforeRestDuration;
    final after = value.afterRestDuration;
    final beforeEnd = before.endDate;
    final afterEnd = after.endDate;

    if (beforeEnd == null || afterEnd == null) {
      return "";
    }

    String f(DateTime date) => DateTimeFormatter.slashMonthAndDay(date);

    return "${f(before.beginDate)}~${f(beforeEnd)}\n↓\n${f(after.beginDate)}~${f(afterEnd)}";
  }

  static String changedRestDurationBeginDate(ChangedRestDurationBeginDateValue value) {
    final before = value.beforeRestDuration;
    final after = value.afterRestDuration;

    String f(DateTime date) => DateTimeFormatter.slashMonthAndDay(date);

    return "${f(before.beginDate)}\n↓\n${f(after.beginDate)}";
  }
}
