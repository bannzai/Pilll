import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// 前回のピルシートグループに対する服用お休み期間の選択範囲の検証を提供する extension
/// 前回のピルシートグループは最終シートを飲み切って終了していることがあり、その場合は
/// [PillSheetGroupRestDurationDomain.targetBeginRestDurationPillSheet] (次のシートを参照する) が使えないため、
/// レコード画面の服用お休み UI とは別に、前回のピルシートグループの期間内で完結する範囲だけを扱う
extension BeforePillSheetGroupRestDurationDomain on PillSheetGroup {
  /// 前回のピルシートグループで服用お休み開始日として選択できる最終日
  /// 服用お休みは最後に服用した日の翌日までにしか開始できない (レコード画面の服用お休み変更と同じ制約)。服用記録が無ければ先頭シートの開始日
  /// また、最終シートの終了予定日より後はどのシートにも属さない (次のピルシートグループの期間) ため、そこも上限にする
  DateTime get latestSelectableRestDurationBeginDateForBeforePillSheetGroup {
    final lastTakenDate = lastTakenPillSheetOrFirstPillSheet.lastTakenDate;
    final afterLastTakenDate = lastTakenDate == null ? pillSheets.first.beginDate.date() : lastTakenDate.date().addDays(1);
    final lastPillSheetEstimatedEndTakenDate = pillSheets.last.estimatedEndTakenDate.date();
    return afterLastTakenDate.isBefore(lastPillSheetEstimatedEndTakenDate) ? afterLastTakenDate : lastPillSheetEstimatedEndTakenDate;
  }

  /// [dateTimeRange] が [excludingRestDuration] 以外の服用お休み期間と重なるかどうか
  /// 服用お休み期間は開始日を含み終了日 (服用再開日) を含まない半開区間として比較する。そのため終了日と次の開始日が同じ日でも重ならない
  /// 終了日が無い (継続中の) 服用お休み期間は開始日以降ずっと続いているものとして扱う
  bool overlapsOtherRestDurationForBeforePillSheetGroup({
    required DateTimeRange dateTimeRange,
    required RestDuration? excludingRestDuration,
  }) {
    return restDurations.where((e) => e != excludingRestDuration).any((other) {
      final otherEndDate = other.endDate;
      final beginsBeforeOtherEnds = otherEndDate == null || dateTimeRange.start.date().isBefore(otherEndDate.date());
      final otherBeginsBeforeEnds = other.beginDate.date().isBefore(dateTimeRange.end.date());
      return beginsBeforeOtherEnds && otherBeginsBeforeEnds;
    });
  }

  /// 前回のピルシートグループの服用お休み期間として [dateTimeRange] を追加・変更できない場合にその理由の文言を返す。できる場合は null
  /// [excludingRestDuration] は変更対象の服用お休み期間で、重なりの判定から除外する。追加の場合は null
  String? restDurationRangeErrorMessageForBeforePillSheetGroup({
    required DateTimeRange dateTimeRange,
    required RestDuration? excludingRestDuration,
  }) {
    // 終了日は服用再開日でお休み期間に含まれないため、開始日と同じ日を選ぶとお休み期間が0日の記録ができてしまう
    if (!dateTimeRange.start.date().isBefore(dateTimeRange.end.date())) {
      return L.pauseEndDateMustBeAfterStartDate;
    }
    final latestSelectableBeginDate = latestSelectableRestDurationBeginDateForBeforePillSheetGroup;
    if (dateTimeRange.start.date().isAfter(latestSelectableBeginDate)) {
      return L.pauseStartDateMustBeOnOrBefore(
        '${DateTimeFormatter.monthAndDay(latestSelectableBeginDate)}(${DateTimeFormatter.shortWeekday(latestSelectableBeginDate)})',
      );
    }
    if (overlapsOtherRestDurationForBeforePillSheetGroup(dateTimeRange: dateTimeRange, excludingRestDuration: excludingRestDuration)) {
      return L.pausePeriodOverlapsOther;
    }
    return null;
  }
}

final addCompletedRestDurationProvider = Provider.autoDispose(
  (ref) => AddCompletedRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);

/// 前回のピルシートグループに、終了日 (服用再開日) が決まっている服用お休み期間を後から追加する
/// レコード画面の服用お休み開始 (BeginRestDuration) は「今日から服用お休み中」を作るが、
/// 前回のピルシートグループでは終了日なしの服用お休みを作ると終了予定日が毎日延び続けてしまうため、終了日つきの期間だけを扱う
/// 服用お休み期間は開始日を含むピルシートに追加し、後続のピルシートの開始日は ChangeRestDuration と同じルールで再計算する
/// 次のピルシートグループ (最新のピルシートグループ) の開始日は変更しない
class AddCompletedRestDuration {
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  AddCompletedRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  Future<PillSheetGroup> call({
    required RestDuration restDuration,
    required PillSheetGroup pillSheetGroup,
  }) async {
    if (restDuration.endDate == null) {
      throw AssertionError('restDuration.endDate is required');
    }

    final targetPillSheetIndex = pillSheetGroup.pillSheets.indexWhere(
      (e) => !restDuration.beginDate.date().isBefore(e.beginDate.date()) && !restDuration.beginDate.date().isAfter(e.estimatedEndTakenDate.date()),
    );
    if (targetPillSheetIndex == -1) {
      throw AssertionError('targetPillSheetIndex is not found');
    }
    final targetPillSheet = pillSheetGroup.pillSheets[targetPillSheetIndex];
    // PillSheet.activeRestDuration は restDurations.last を見るため、過去の期間を後から追加しても継続中の服用お休みが末尾に残るように開始日順に並べる
    final updatedTargetPillSheet = targetPillSheet.copyWith(
      restDurations: [...targetPillSheet.restDurations, restDuration].sortedBy((e) => e.beginDate),
    );

    // beginDateをアップデート。ChangeRestDuration と同じく、このループ内で更新した前のピルシートを用いて算出する
    final updatedBeginDatePillSheets = <PillSheet>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      // PillSheet.id は nullable のため、null 同士の比較で全シートが対象扱いにならないように groupIndex で対象シートを判定する
      final isTargetPillSheet = pillSheet.groupIndex == targetPillSheet.groupIndex;
      if (pillSheet.groupIndex == 0) {
        updatedBeginDatePillSheets.add(isTargetPillSheet ? updatedTargetPillSheet : pillSheet);
        continue;
      }
      final beforePillSheet = updatedBeginDatePillSheets[pillSheet.groupIndex - 1];
      updatedBeginDatePillSheets.add(
        (isTargetPillSheet ? updatedTargetPillSheet : pillSheet).copyWith(
          beginDate: beforePillSheet.estimatedEndTakenDate.date().addDays(1),
        ),
      );
    }

    // 対象より後ろのピルシートは開始日が後ろにずれるので、ChangeRestDuration と同じく beginDate > lastTakenDate にならないように服用記録をクリアする
    final updatedPillSheets = <PillSheet>[];
    for (final pillSheet in updatedBeginDatePillSheets) {
      if (pillSheet.groupIndex <= updatedTargetPillSheet.groupIndex || pillSheet.restDurations.isNotEmpty) {
        updatedPillSheets.add(pillSheet);
        continue;
      }
      switch (pillSheet) {
        case PillSheetV1():
          updatedPillSheets.add(pillSheet.copyWith(lastTakenDate: null));
        case PillSheetV2():
          // v2ではpillTakensをクリアすることでlastTakenDateがnullになる
          updatedPillSheets.add(pillSheet.copyWith(pills: pillSheet.pills.map((p) => p.copyWith(pillTakens: [])).toList()));
      }
    }

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    // 開始と終了をまとめて記録するので、履歴も服用お休み開始・服用お休み終了の 2 件を残す
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        restDuration: restDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        restDuration: restDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );
    await batch.commit();

    return updatedPillSheetGroup;
  }
}
