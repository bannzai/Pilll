import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class PillNumber extends StatelessWidget {
  const PillNumber({super.key, required this.pillNumber});

  final String pillNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      pillNumber,
      style: const TextStyle(color: TextColor.main, fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400),
      textAlign: TextAlign.start,
    );
  }
}

abstract class PillSheetModifiedHistoryPillNumberOrDate {
  static String hyphen() => '-';

  /// 表示モードに応じて「n番」または「n日目」形式で表示する
  static String _formatPillNumber(String numberString, {required PillSheetAppearanceMode pillSheetAppearanceMode}) {
    if (pillSheetAppearanceMode.isSequential) {
      return L.withDay(numberString);
    }
    return L.withNumber(numberString);
  }

  static String taken({
    required int? beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    // beforePillSheetの最後に飲んだ番号+1から服用記録が始まる
    // nullの場合は服用記録を取り消したり、服用日を移動した際にありえる
    // また、1つ前のピルシートの最後の番号の時もnullになる
    final left = (beforeLastTakenPillNumber ?? 0) + 1;
    // 1度飲みの時に本日分を服用した場合は1錠分の服用履歴を表示する
    if (left == afterLastTakenPillNumber) {
      return _formatPillNumber('$afterLastTakenPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);
    }
    return _formatPillNumber('$left-$afterLastTakenPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);
  }

  static String autoTaken({
    required int beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    // beforePillSheetの最後に飲んだ番号+1から服用記録が始まる
    final left = beforeLastTakenPillNumber + 1;
    if (left == afterLastTakenPillNumber) {
      return _formatPillNumber('$afterLastTakenPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);
    }
    return _formatPillNumber('$left-$afterLastTakenPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);
  }

  static String revert({
    required int beforeLastTakenPillNumber,
    required int? afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    if (afterLastTakenPillNumber == null) {
      return _formatPillNumber('$beforeLastTakenPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);
    }
    // 1度飲みのrevertは1錠分の服用履歴を表示する
    if (beforeLastTakenPillNumber == (afterLastTakenPillNumber + 1)) {
      return _formatPillNumber('$beforeLastTakenPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);
    }
    return _formatPillNumber('$beforeLastTakenPillNumber-${afterLastTakenPillNumber + 1}', pillSheetAppearanceMode: pillSheetAppearanceMode);
  }

  static String changedPillNumber({
    required int beforeTodayPillNumber,
    required int afterTodayPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) => _formatPillNumber('$beforeTodayPillNumber→$afterTodayPillNumber', pillSheetAppearanceMode: pillSheetAppearanceMode);

  static String changedBeginDisplayNumberSetting(ChangedBeginDisplayNumberValue value) {
    // 表示番号設定の変更履歴は常に「番」表記（これはピルシートの物理的な番号なため）
    final before = value.beforeDisplayNumberSetting;
    if (before == null || before.beginPillNumber == null) {
      return L.withNumber('1→${value.afterDisplayNumberSetting.beginPillNumber}');
    }
    return L.withNumber('${before.beginPillNumber}→${value.afterDisplayNumberSetting.beginPillNumber}');
  }

  static String changedEndDisplayNumberSetting(ChangedEndDisplayNumberValue value) {
    // 表示番号設定の変更履歴は常に「番」表記（これはピルシートの物理的な番号なため）
    final before = value.beforeDisplayNumberSetting;
    if (before == null || before.endPillNumber == null) {
      return L.withNumber('1→${value.afterDisplayNumberSetting.endPillNumber}');
    }
    return L.withNumber('${before.endPillNumber}→${value.afterDisplayNumberSetting.endPillNumber}');
  }

  static String pillSheetCount(List<String> pillSheetIDs) => pillSheetIDs.isNotEmpty ? L.withPillSheetCount(pillSheetIDs.length) : hyphen();

  static String changedRestDuration(ChangedRestDurationValue value) {
    final before = value.beforeRestDuration;
    final after = value.afterRestDuration;
    final beforeEnd = before.endDate;
    final afterEnd = after.endDate;

    if (beforeEnd == null || afterEnd == null) {
      return '';
    }

    String f(DateTime date) => DateTimeFormatter.slashMonthAndDay(date);

    return '${f(before.beginDate)}~${f(beforeEnd)}\n↓\n${f(after.beginDate)}~${f(afterEnd)}';
  }

  static String changedRestDurationBeginDate(ChangedRestDurationBeginDateValue value) {
    final before = value.beforeRestDuration;
    final after = value.afterRestDuration;

    String f(DateTime date) => DateTimeFormatter.slashMonthAndDay(date);

    return '${f(before.beginDate)}\n↓\n${f(after.beginDate)}';
  }
}
