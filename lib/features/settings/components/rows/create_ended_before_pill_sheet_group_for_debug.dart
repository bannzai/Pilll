import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';

/// 開発者オプション内の行。タップすると、現在のピルシートグループを「途中まで服用したまま終了した前回のピルシートグループ」に作り替え、
/// 今日から始まる新しいピルシートグループを作成する。前回のピルシートグループ画面での服用お休み期間の追加・変更の動作確認に使う
class CreateEndedBeforePillSheetGroupForDebugRow extends HookConsumerWidget {
  const CreateEndedBeforePillSheetGroupForDebugRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // バッチ書き込みの await 中に連続タップされると同じ pillSheetGroup を入力に多重実行されるため、処理中はタップを無効化する
    final isProcessing = useState(false);
    return ListTile(
      title: const Text('終了済みの前回ピルシートグループを作成'),
      subtitle: const Text('現在のピルシートグループを過去にずらして途中まで服用済みの終了状態にし、今日から始まる新しいピルシートグループを作る'),
      trailing: const Icon(Icons.history),
      enabled: !isProcessing.value,
      onTap: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final pillSheetGroup = ref.read(latestPillSheetGroupProvider).valueOrNull;
        final setting = ref.read(settingProvider).valueOrNull;
        if (pillSheetGroup == null || setting == null) {
          scaffoldMessenger.showSnackBar(const SnackBar(content: Text('ピルシートグループがありません')));
          return;
        }
        isProcessing.value = true;
        try {
          await ref.read(createEndedBeforePillSheetGroupForDebugProvider).call(pillSheetGroup: pillSheetGroup, setting: setting);
          scaffoldMessenger.showSnackBar(const SnackBar(content: Text('終了済みの前回ピルシートグループを作成しました')));
        } finally {
          isProcessing.value = false;
        }
      },
    );
  }
}

final createEndedBeforePillSheetGroupForDebugProvider = Provider.autoDispose(
  (ref) => CreateEndedBeforePillSheetGroupForDebug(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

/// 開発用: 現在のピルシートグループを終了済みの前回のピルシートグループに作り替え、新しいピルシートグループを作成する
class CreateEndedBeforePillSheetGroupForDebug {
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  CreateEndedBeforePillSheetGroupForDebug({required this.batchFactory, required this.batchSetPillSheetGroup});

  Future<void> call({required PillSheetGroup pillSheetGroup, required Setting setting}) async {
    if (!Environment.isDevelopment) {
      throw AssertionError('This method should not call out of development');
    }

    // restDurations をクリアした後の各ピルシートの終了予定日 (beginDate + totalCount - 1) の最大値が、
    // 今日より確実に前になる日数だけ過去にずらす。beginDate が元の服用お休みで後ろにずれているグループでも終了済みになるようにする
    // 12 は自動作成された次のグループの開始日 (今日) と重ならないための余白日数
    final latestEstimatedEndTakenDate =
        pillSheetGroup.pillSheets.map((e) => e.beginDate.date().addDays(e.typeInfo.totalCount - 1)).sorted((a, b) => a.compareTo(b)).last;
    // 既に終了予定日が過去の場合に shiftDays が負になって未来へずらさないように 0 でクランプする
    final shiftDays = max(daysBetween(today(), latestEstimatedEndTakenDate), 0) + 12;
    // 1枚目は21番目まで服用済み、2枚目以降は未服用にする (途中で服用をやめたまま終了した状態)
    const lastTakenPillNumber = 21;
    final endedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      final beginDate = pillSheet.beginDate.date().addDays(-shiftDays);
      final lastTakenDate = pillSheet.groupIndex == 0 ? beginDate.addDays(lastTakenPillNumber - 1) : null;
      switch (pillSheet) {
        case PillSheetV1():
          return pillSheet.copyWith(beginDate: beginDate, lastTakenDate: lastTakenDate, restDurations: []);
        case PillSheetV2():
          return pillSheet.copyWith(
            beginDate: beginDate,
            restDurations: [],
            pills: Pill.generateAndFillTo(
              pillSheetType: pillSheet.pillSheetType,
              fromDate: beginDate,
              lastTakenDate: lastTakenDate,
              pillTakenCount: pillSheetGroup.pillTakenCount,
            ),
          );
      }
    }).toList();
    final endedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: endedPillSheets);

    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, endedPillSheetGroup);
    batchSetPillSheetGroup(
      batch,
      buildPillSheetGroup(
        setting: setting,
        pillSheetGroup: endedPillSheetGroup,
        pillSheetTypes: pillSheetGroup.pillSheetTypes,
        displayNumberSetting: null,
        pillTakenCount: pillSheetGroup.pillTakenCount,
      ),
    );
    await batch.commit();
  }
}
