import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';

final beginRestDurationProvider = Provider.autoDispose(
  (ref) => BeginRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(
      batchSetPillSheetModifiedHistoryProvider,
    ),
  ),
);

class BeginRestDuration {
  final BatchFactory batchFactory;

  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  BeginRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  /// 服用お休みを開始する。[endDate] は任意の服用再開予定日
  /// [endDate] がある時は、後続のピルシートの beginDate を予定の終了日まで全日数含めた予定終了日の翌日に確定して保存する
  /// バックエンドは endDate がある服用お休みを日送りしないため、アプリが開始時点で確定する必要がある
  /// [endDate] が無い時は後続のピルシートを変えない（バックエンドが毎日日送りする）
  Future<void> call({
    required PillSheetGroup pillSheetGroup,
    required DateTime? endDate,
  }) async {
    final batch = batchFactory.batch();

    final restDuration = RestDuration(
      id: firestoreIDGenerator(),
      beginDate: pillSheetGroup.availableRestDurationBeginDate,
      endDate: endDate,
      createdDate: now(),
    );

    final updatedPillSheet = pillSheetGroup.targetBeginRestDurationPillSheet.copyWith(
      restDurations: [
        ...pillSheetGroup.targetBeginRestDurationPillSheet.restDurations,
        restDuration,
      ],
    );
    final PillSheetGroup updatedPillSheetGroup;
    if (endDate == null) {
      updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    } else {
      final updatedPillSheets = <PillSheet>[];
      for (final pillSheet in pillSheetGroup.pillSheets) {
        if (pillSheet.groupIndex == updatedPillSheet.groupIndex) {
          updatedPillSheets.add(updatedPillSheet);
        } else if (pillSheet.groupIndex > updatedPillSheet.groupIndex) {
          // 前のピルシートのbeginDateが更新され、estimatedEndTakenDateが変わっている場合も考慮する必要があるのでupdatedPillSheetsから1つ前のピルシートにアクセスする
          updatedPillSheets.add(
            pillSheet.copyWith(
              beginDate: updatedPillSheets[pillSheet.groupIndex - 1].estimatedEndTakenDateWithPlannedResume.date().addDays(1),
            ),
          );
        } else {
          updatedPillSheets.add(pillSheet);
        }
      }
      updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    }

    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        restDuration: restDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );

    await batch.commit();
  }
}

final endRestDurationProvider = Provider.autoDispose(
  (ref) => EndRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(
      batchSetPillSheetModifiedHistoryProvider,
    ),
  ),
);

class EndRestDuration {
  final BatchFactory batchFactory;

  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  EndRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  Future<PillSheetGroup> call({
    required RestDuration restDuration,
    required PillSheet activePillSheet,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final batch = batchFactory.batch();
    final updatedRestDuration = restDuration.copyWith(endDate: now());
    final updatedPillSheet = activePillSheet.copyWith(
      restDurations: [...activePillSheet.restDurations]..replaceRange(
          activePillSheet.restDurations.length - 1,
          activePillSheet.restDurations.length,
          [updatedRestDuration],
        ),
    );
    final updatedPillSheets = <PillSheet>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      if (pillSheet.id == activePillSheet.id) {
        updatedPillSheets.add(updatedPillSheet);
      } else if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        // activePillSheetよりも後のピルシートで、前のピルシートのbeginDateが更新され、estimatedEndTakenDateが変わっている場合も考慮する必要があるのでupdatedPillSheetsから1つ前のピルシートにアクセスする
        final beforeUpdatedPillSheet = updatedPillSheets[pillSheet.groupIndex - 1];
        updatedPillSheets.add(
          pillSheet.copyWith(
            beginDate: beforeUpdatedPillSheet.estimatedEndTakenDate.add(
              const Duration(days: 1),
            ),
          ),
        );
      } else {
        updatedPillSheets.add(pillSheet);
      }
    }

    final updatedPillSheetGroup = pillSheetGroup.copyWith(
      pillSheets: updatedPillSheets,
    );
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        restDuration: updatedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );
    await batch.commit();

    return updatedPillSheetGroup;
  }
}

final changeRestDurationBeginDateProvider = Provider.autoDispose(
  (ref) => ChangeRestDuration(
    actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(
      batchSetPillSheetModifiedHistoryProvider,
    ),
  ),
);
final changeRestDurationProvider = Provider.autoDispose(
  (ref) => ChangeRestDuration(
    actionType: PillSheetModifiedActionType.changedRestDuration,
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(
      batchSetPillSheetModifiedHistoryProvider,
    ),
  ),
);

class ChangeRestDuration {
  // changedRestDurationBeginDate or changedRestDuration
  final PillSheetModifiedActionType actionType;
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  ChangeRestDuration({
    required this.actionType,
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  bool _hasRestDuration(PillSheet pillSheet, RestDuration restDuration) {
    // restDuration.idが2024-03-28の実装時に追加されたものでnullableの可能性がある。
    // idチェックをしているが後述の期間をチェックする処理でもほぼ問題ない
    // また、toRestDurationの場合はマッチするIDが無いのでどちらにしてもidではなく期間で絞る必要がある
    if (pillSheet.restDurations.map((e) => e.id).where((e) => e != null).contains(restDuration.id)) {
      return true;
    }
    return !restDuration.beginDate.isBefore(pillSheet.beginDate) && !restDuration.beginDate.isAfter(pillSheet.estimatedEndTakenDate);
  }

  /// 開始日の昇順に並べた服用お休み期間を返す。末尾が最新の期間であることを前提にする処理
  /// ([PillSheet.activeRestDuration]・[PillSheet.estimatedEndTakenDateWithPlannedResume] など)のため、過去の期間を変更して末尾に追加しても順序を保つ
  List<RestDuration> _sortedByBeginDate(List<RestDuration> restDurations) {
    return [...restDurations]..sort((a, b) => a.beginDate.compareTo(b.beginDate));
  }

  Future<void> call({
    required RestDuration fromRestDuration,
    required RestDuration toRestDuration,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final fromRestDurationPillSheetIndex = pillSheetGroup.pillSheets.indexWhere(
      (e) => _hasRestDuration(e, fromRestDuration),
    );
    if (fromRestDurationPillSheetIndex == -1) {
      throw AssertionError('fromRestDurationPillSheetIndex is not found');
    }
    final fromRestDurationPillSheet = pillSheetGroup.pillSheets[fromRestDurationPillSheetIndex];
    if (fromRestDurationPillSheet.restDurations.isEmpty) {
      throw AssertionError('fromRestDurationPillSheet.restDurations is empty');
    }
    final fromRestDurationIndex = fromRestDurationPillSheet.restDurations.indexOf(fromRestDuration);
    if (fromRestDurationIndex == -1) {
      throw AssertionError('fromRestDurationIndex is not found');
    }
    final updatedFromRestDurationPillSheet = fromRestDurationPillSheet.copyWith(
      restDurations: [...fromRestDurationPillSheet.restDurations]..removeAt(fromRestDurationIndex),
    );

    final toRestDurationPillSheetIndex = pillSheetGroup.pillSheets.indexWhere(
      (e) => _hasRestDuration(e, toRestDuration),
    );
    if (toRestDurationPillSheetIndex == -1) {
      throw AssertionError('toRestDurationPillSheetIndex is not found');
    }
    final PillSheet updatedToRestDurationPillSheet;
    final toRestDurationPillSheet = pillSheetGroup.pillSheets[toRestDurationPillSheetIndex];
    if (updatedFromRestDurationPillSheet.id == toRestDurationPillSheet.id) {
      // 変更前後のお休み期間対象のピルシートが一緒の場合はupdatedFromRestDurationPillSheetからコピーする
      updatedToRestDurationPillSheet = updatedFromRestDurationPillSheet.copyWith(
        restDurations: _sortedByBeginDate([
          ...updatedFromRestDurationPillSheet.restDurations,
          toRestDuration,
        ]),
      );
    } else {
      updatedToRestDurationPillSheet = toRestDurationPillSheet.copyWith(
        restDurations: _sortedByBeginDate([
          ...toRestDurationPillSheet.restDurations,
          toRestDuration,
        ]),
      );
    }

    // 先に服用お休み期間を更新する
    // 後述のループでbeginDateを更新する
    final updatedRestDurationPillSheets = <PillSheet>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      // updatedToRestDurationPillSheet からチェックする。updatedFromRestDurationPillSheet.id == toRestDurationPillSheet.id の場合は
      // if (pillSheet.id == updatedFromRestDurationPillSheet.id)の条件式には引っかからない
      if (pillSheet.id == updatedToRestDurationPillSheet.id) {
        updatedRestDurationPillSheets.add(updatedToRestDurationPillSheet);
      } else if (pillSheet.id == updatedFromRestDurationPillSheet.id) {
        updatedRestDurationPillSheets.add(updatedFromRestDurationPillSheet);
      } else {
        updatedRestDurationPillSheets.add(pillSheet);
      }
    }

    // beginingDateをアップデート
    final updatedBeginingDatePillSheets = <PillSheet>[];
    for (final pillSheet in updatedRestDurationPillSheets) {
      if (pillSheet.id == updatedRestDurationPillSheets.first.id) {
        updatedBeginingDatePillSheets.add(pillSheet);
        continue;
      }

      /// このループ内でアップデートされた前のピルシートを用いてbeginingDateを算出するので、
      /// [updatedBeginingDatePillSheets] から取得する
      final beforePillSheet = updatedBeginingDatePillSheets[pillSheet.groupIndex - 1];
      updatedBeginingDatePillSheets.add(
        pillSheet.copyWith(
          beginDate: beforePillSheet.estimatedEndTakenDateWithPlannedResume.date().addDays(1),
        ),
      );
    }

    // lastTakenDateをクリアする
    final updatedPillSheets = <PillSheet>[];
    for (final pillSheet in updatedBeginingDatePillSheets) {
      if (pillSheet.groupIndex <= updatedToRestDurationPillSheet.groupIndex) {
        updatedPillSheets.add(pillSheet);
        continue;
      }

      // updatedToRestDurationPillSheetよりも後ろのピルシートは、lastTakenDateをクリアしてしまう
      // ピル番号の表示するロジックで、beginingDate > lastTakenDateのような状態になると困る
      // 対象のピルシートにrestDurationsが含まれていない場合にlastTakenDateをクリアする
      if (pillSheet.restDurations.isEmpty) {
        // v1/v2で分岐: v2ではlastTakenDateはpillsから導出されるため、pillsをクリアする必要がある
        switch (pillSheet) {
          case PillSheetV1():
            updatedPillSheets.add(pillSheet.copyWith(lastTakenDate: null));
          case PillSheetV2():
            // v2ではpillTakensをクリアすることでlastTakenDateがnullになる
            updatedPillSheets.add(
              pillSheet.copyWith(
                pills: pillSheet.pills.map((p) => p.copyWith(pillTakens: [])).toList(),
              ),
            );
        }
      } else {
        updatedPillSheets.add(pillSheet);
      }
    }

    final batch = batchFactory.batch();
    final updatedPillSheetGroup = pillSheetGroup.copyWith(
      pillSheets: updatedPillSheets.map((pillSheet) => _clampLastTakenDate(pillSheet: pillSheet)).toList(),
    );
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    switch (actionType) {
      case PillSheetModifiedActionType.changedRestDurationBeginDate:
        batchSetPillSheetModifiedHistory(
          batch,
          PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
            beforeRestDuration: fromRestDuration,
            afterRestDuration: toRestDuration,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: updatedPillSheetGroup,
          ),
        );
      case PillSheetModifiedActionType.changedRestDuration:
        batchSetPillSheetModifiedHistory(
          batch,
          PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
            beforeRestDuration: fromRestDuration,
            afterRestDuration: toRestDuration,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: updatedPillSheetGroup,
          ),
        );
      default:
        throw AssertionError('actionType is not supported: $actionType');
    }

    await batch.commit();
  }
}

/// 服用お休み期間の変更・削除で終了予定日が前倒しになった時に、lastTakenDateが終了予定日より後に残らないよう補正したピルシートを返す。
/// 補正しないと PillSheet.pillNumberFor が錠数を超えるピル番号を返す。
/// 補正の条件に当てはまらないピルシートはそのまま返す。補正済みのピルシートに再度適用しても結果は変わらない(冪等)。
PillSheet _clampLastTakenDate({required PillSheet pillSheet}) {
  return switch (pillSheet) {
    PillSheetV1(:final lastTakenDate?) when lastTakenDate.date().isAfter(pillSheet.estimatedEndTakenDate.date()) => pillSheet.copyWith(
        lastTakenDate: pillSheet.estimatedEndTakenDate.date(),
      ),
    PillSheetV1() => pillSheet,
    // v2のピル番号は日付から逆算せずpillsのindexから決まるため、lastTakenDateが終了予定日より後でも錠数を超えない。
    // pillTakensは実際の服用記録なので変更しない
    PillSheetV2() => pillSheet,
  };
}

final deleteRestDurationProvider = Provider.autoDispose(
  (ref) => DeleteRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(
      batchSetPillSheetModifiedHistoryProvider,
    ),
  ),
);

/// 記録済みの服用お休み期間 (継続中・終了済みのどちらも) を削除する
/// 誤って開始した服用お休みなど、服用お休みがなかったものとしてピルシートの日付を計算し直したい時に使う
class DeleteRestDuration {
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  DeleteRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  /// [pillSheetGroup] から [restDuration] を取り除いて保存し、削除後のピルシートグループを返す
  /// 後続のピルシートの開始日は ChangeRestDuration と同じルールで再計算する。削除で開始日は前にずれるだけなので、ChangeRestDuration のように後続のピルシートの服用記録はクリアしない
  /// [restDuration] がどのピルシートにも含まれない時は AssertionError を投げる
  Future<PillSheetGroup> call({
    required RestDuration restDuration,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final targetPillSheet = pillSheetGroup.pillSheets.firstWhereOrNull((e) => e.restDurations.contains(restDuration));
    if (targetPillSheet == null) {
      throw AssertionError('restDuration is not found in pillSheetGroup');
    }

    final updatedPillSheets = <PillSheet>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      // PillSheet.id は nullable のため、null 同士の比較で全シートが対象扱いにならないように groupIndex で対象シートを判定する
      if (pillSheet.groupIndex < targetPillSheet.groupIndex) {
        updatedPillSheets.add(pillSheet);
      } else if (pillSheet.groupIndex == targetPillSheet.groupIndex) {
        updatedPillSheets.add(
          _clampLastTakenDate(
            pillSheet: pillSheet.copyWith(restDurations: [...pillSheet.restDurations]..remove(restDuration)),
          ),
        );
      } else {
        // このループ内で更新した前のピルシートの終了予定日から算出するので updatedPillSheets から取得する
        updatedPillSheets.add(
          _clampLastTakenDate(
            pillSheet: pillSheet.copyWith(
              beginDate: updatedPillSheets[pillSheet.groupIndex - 1].estimatedEndTakenDateWithPlannedResume.date().addDays(1),
            ),
          ),
        );
      }
    }

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createDeletedRestDurationAction(
        restDuration: restDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );
    await batch.commit();

    return updatedPillSheetGroup;
  }
}
