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
  static String hyphen() => '-';

  /// 表示モードに応じて「n番」または「n日目」形式で表示する
  static String _formatPillNumber(
    String numberString, {
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    if (pillSheetAppearanceMode.isSequential) {
      return L.withDay(numberString);
    }
    return L.withNumber(numberString);
  }

  /// v1（1錠飲み）用の服用履歴表示文字列を生成
  static String taken({
    required int? beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    // beforePillSheetの最後に飲んだ番号+1から服用記録が始まる
    // nullの場合は服用記録を取り消したり、服用日を移動した際にありえる
    // また、1つ前のピルシートの最後の番号の時もnullになる
    final left = (beforeLastTakenPillNumber ?? 0) + 1;
    // 1錠分の服用履歴を表示するケース:
    // - 1度飲みの時に本日分を服用した場合
    if (left == afterLastTakenPillNumber) {
      return _formatPillNumber(
        '$afterLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    return _formatPillNumber(
      '$left-$afterLastTakenPillNumber',
      pillSheetAppearanceMode: pillSheetAppearanceMode,
    );
  }

  /// v2（2錠飲み）用の服用履歴表示文字列を生成
  /// v2では同じピルを複数回服用するため、before == after のケースがある
  static String takenV2({
    required int? beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    // v2で同じピルを2回目服用した場合、before == after になる
    if (beforeLastTakenPillNumber == afterLastTakenPillNumber) {
      return _formatPillNumber(
        '$afterLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    final left = (beforeLastTakenPillNumber ?? 0) + 1;
    if (left == afterLastTakenPillNumber) {
      return _formatPillNumber(
        '$afterLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    return _formatPillNumber(
      '$left-$afterLastTakenPillNumber',
      pillSheetAppearanceMode: pillSheetAppearanceMode,
    );
  }

  static String autoTaken({
    required int beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    // beforePillSheetの最後に飲んだ番号+1から服用記録が始まる
    final left = beforeLastTakenPillNumber + 1;
    if (left == afterLastTakenPillNumber) {
      return _formatPillNumber(
        '$afterLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    return _formatPillNumber(
      '$left-$afterLastTakenPillNumber',
      pillSheetAppearanceMode: pillSheetAppearanceMode,
    );
  }

  /// v1（1錠飲み）用の服用取り消し履歴表示文字列を生成
  static String revert({
    required int beforeLastTakenPillNumber,
    required int? afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    if (afterLastTakenPillNumber == null) {
      return _formatPillNumber(
        '$beforeLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    // 1度飲みのrevertは1錠分の服用履歴を表示する
    if (beforeLastTakenPillNumber == (afterLastTakenPillNumber + 1)) {
      return _formatPillNumber(
        '$beforeLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    return _formatPillNumber(
      '$beforeLastTakenPillNumber-${afterLastTakenPillNumber + 1}',
      pillSheetAppearanceMode: pillSheetAppearanceMode,
    );
  }

  /// v2（2錠飲み）用の服用取り消し履歴表示文字列を生成
  static String revertV2({
    required int beforeLastTakenPillNumber,
    required int? afterLastTakenPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    if (afterLastTakenPillNumber == null) {
      return _formatPillNumber(
        '$beforeLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    // v2で同じピルの2回目服用を取り消した場合、before == after になる
    if (beforeLastTakenPillNumber == afterLastTakenPillNumber) {
      return _formatPillNumber(
        '$beforeLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    if (beforeLastTakenPillNumber == (afterLastTakenPillNumber + 1)) {
      return _formatPillNumber(
        '$beforeLastTakenPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );
    }
    return _formatPillNumber(
      '$beforeLastTakenPillNumber-${afterLastTakenPillNumber + 1}',
      pillSheetAppearanceMode: pillSheetAppearanceMode,
    );
  }

  static String changedPillNumber({
    required int beforeTodayPillNumber,
    required int afterTodayPillNumber,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) =>
      _formatPillNumber(
        '$beforeTodayPillNumber→$afterTodayPillNumber',
        pillSheetAppearanceMode: pillSheetAppearanceMode,
      );

  static String changedBeginDisplayNumberSetting({
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup? afterPillSheetGroup,
  }) {
    // 表示番号設定の変更履歴は常に「番」表記（これはピルシートの物理的な番号なため）
    final before = beforePillSheetGroup?.displayNumberSetting;
    final after = afterPillSheetGroup?.displayNumberSetting;
    if (before == null || before.beginPillNumber == null) {
      return L.withNumber('1→${after?.beginPillNumber ?? 1}');
    }
    return L.withNumber(
      '${before.beginPillNumber}→${after?.beginPillNumber ?? 1}',
    );
  }

  static String changedEndDisplayNumberSetting({
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup? afterPillSheetGroup,
  }) {
    // 表示番号設定の変更履歴は常に「番」表記（これはピルシートの物理的な番号なため）
    final before = beforePillSheetGroup?.displayNumberSetting;
    final after = afterPillSheetGroup?.displayNumberSetting;
    if (before == null || before.endPillNumber == null) {
      return L.withNumber('1→${after?.endPillNumber ?? 1}');
    }
    return L.withNumber('${before.endPillNumber}→${after?.endPillNumber ?? 1}');
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

  static String changedRestDurationBeginDate(
    ChangedRestDurationBeginDateValue value,
  ) {
    final before = value.beforeRestDuration;
    final after = value.afterRestDuration;

    String f(DateTime date) => DateTimeFormatter.slashMonthAndDay(date);

    return '${f(before.beginDate)}\n↓\n${f(after.beginDate)}';
  }
}
