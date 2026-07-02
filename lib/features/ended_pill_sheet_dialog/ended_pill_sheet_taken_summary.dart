import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';

/// 終了したピルシートグループの服用記録サマリ。
/// recordedDays = 服用記録できた日数（x）、missedDays = 記録漏れ日数（y）。
/// [beginDate]（シート開始日）〜[endDate]（最終服用予定日、両端含む）を集計期間とする。
/// 開始日から数日後に初回記録した場合や一度も記録しなかった場合でも、未記録日を missedDays に含める。
({int recordedDays, int missedDays}) endedPillSheetTakenSummary({
  required List<PillSheetModifiedHistory> histories,
  required DateTime beginDate,
  required DateTime endDate,
}) {
  // pillTakenDateSets の上限は排他的（daysBetween で上限日を含めない）なので、endDate を含めるため翌日を渡す
  final sets = pillTakenDateSets(
    histories: histories,
    beginDate: beginDate,
    maxDate: endDate.add(const Duration(days: 1)),
  );
  if (sets == null) {
    return (recordedDays: 0, missedDays: 0);
  }
  final missedDays = sets.scheduledDates.difference(sets.takenDates).length;
  return (
    recordedDays: sets.scheduledDates.length - missedDays,
    missedDays: missedDays,
  );
}
