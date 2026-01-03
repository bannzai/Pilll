import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/pill_sheet_group.dart';

final changePillTakenCountProvider = Provider.autoDispose(
  (ref) => ChangePillTakenCount(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class ChangePillTakenCount {
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  ChangePillTakenCount({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
  });

  Future<void> call({
    required PillSheetGroup pillSheetGroup,
    required int pillTakenCount,
  }) async {
    final batch = batchFactory.batch();
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      return;
    }

    // 全てのピルシートのpillTakenCountを更新
    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      // pillsの再生成
      final updatedPills = Pill.generateAndFillTo(
        pillSheetType: pillSheet.pillSheetType,
        fromDate: pillSheet.beginingDate,
        lastTakenDate: pillSheet.lastTakenDate,
        pillTakenCount: pillTakenCount,
      );
      // V1の場合はV2に変換、V2の場合はpillsを更新
      return switch (pillSheet) {
        PillSheetV1(
          :final id,
          :final typeInfo,
          :final beginingDate,
          :final lastTakenDate,
          :final createdAt,
          :final deletedAt,
          :final groupIndex,
          :final restDurations
        ) =>
          PillSheet.v2(
            id: id,
            typeInfo: typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: lastTakenDate,
            createdAt: createdAt,
            deletedAt: deletedAt,
            groupIndex: groupIndex,
            restDurations: restDurations,
            pillTakenCount: pillTakenCount,
            pills: updatedPills,
          ),
        PillSheetV2() => pillSheet.copyWith(
            pillTakenCount: pillTakenCount,
            pills: updatedPills,
          ),
      };
    }).toList();

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);

    // NOTE: 履歴記録は簡略化のため省略。将来的に必要であれば追加する
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    await batch.commit();
  }
}
