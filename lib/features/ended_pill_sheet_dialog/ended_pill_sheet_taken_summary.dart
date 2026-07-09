import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

/// 終了したピルシートグループの服用記録サマリ。
/// recordedDays = 服用記録できた日数（x）、missedDays = 記録漏れ日数（y）。
/// 服用予定日は各シートの錠剤日付のうち実薬分（dosingPeriod）のみを対象とし、
/// 偽薬・休薬期間は記録漏れに含めない。服用お休みによる日付シフトは PillSheet.buildDates が織り込む。
({int recordedDays, int missedDays}) endedPillSheetTakenSummary({
  required PillSheetGroup pillSheetGroup,
  required List<PillSheetModifiedHistory> histories,
}) {
  final scheduledDates = pillSheetGroup.pillSheets
      .expand((pillSheet) => pillSheet.buildDates().take(pillSheet.pillSheetType.dosingPeriod))
      .map((pillTakeDate) => pillTakeDate.date())
      .toSet();
  final takenDates = pillTakenDateSets(
        histories: histories,
        beginDate: pillSheetGroup.pillSheets.first.beginDate,
        // pillTakenDateSets の上限は排他的なので、最終服用予定日を含めるため翌日を渡す
        maxDate: pillSheetGroup.pillSheets.last.estimatedEndTakenDate.add(const Duration(days: 1)),
      )?.takenDates ??
      {};
  final missedDays = scheduledDates.difference(takenDates).length;
  return (
    recordedDays: scheduledDates.length - missedDays,
    missedDays: missedDays,
  );
}
