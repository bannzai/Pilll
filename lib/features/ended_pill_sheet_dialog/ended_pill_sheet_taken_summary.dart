import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';

/// 終了したピルシートグループの服用記録サマリ。
/// recordedDays = 服用記録できた日数（x）、missedDays = 記録漏れ日数（y）。
/// y は既存の服用遵守ロジック [missedPillDays] に委譲し、x は (服用予定日数 − y) で求める。
({int recordedDays, int missedDays}) endedPillSheetTakenSummary({
  required List<PillSheetModifiedHistory> histories,
  required DateTime maxDate,
}) {
  final missedDays = missedPillDays(histories: histories, maxDate: maxDate);
  return (
    recordedDays: scheduledPillDays(histories: histories, maxDate: maxDate) - missedDays,
    missedDays: missedDays,
  );
}
