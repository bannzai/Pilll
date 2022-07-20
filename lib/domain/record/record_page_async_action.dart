import 'dart:async';
import 'dart:math';

import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/util/take_pill.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

class RecordPageAsyncAction {
  final BatchFactory _batchFactory;
  final PillSheetDatastore _pillSheetDatastore;
  final SettingDatastore _settingDatastore;
  final PillSheetModifiedHistoryDatastore _pillSheetModifiedHistoryDatastore;
  final PillSheetGroupDatastore _pillSheetGroupDatastore;

  RecordPageAsyncAction(
    this._batchFactory,
    this._pillSheetDatastore,
    this._settingDatastore,
    this._pillSheetModifiedHistoryDatastore,
    this._pillSheetGroupDatastore,
  );

  Future<bool> _take({required DateTime takenDate, required PillSheetGroup pillSheetGroup}) async {
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("active pill sheet not found");
    }
    if (activedPillSheet.todayPillIsAlreadyTaken) {
      return false;
    }
    final takePill = TakePill(
      pillSheetGroup: pillSheetGroup,
      activedPillSheet: activedPillSheet,
      batchFactory: _batchFactory,
      pillSheetDatastore: _pillSheetDatastore,
      pillSheetModifiedHistoryDatastore: _pillSheetModifiedHistoryDatastore,
      pillSheetGroupDatastore: _pillSheetGroupDatastore,
    );
    final updatedPillSheetGroup = await takePill(
      takenDate: takenDate,
      isQuickRecord: false,
    );
    if (updatedPillSheetGroup == null) {
      return false;
    }
    return true;
  }

  Future<bool> taken({required PillSheetGroup pillSheetGroup}) {
    return _take(takenDate: now(), pillSheetGroup: pillSheetGroup);
  }

  Future<bool> takenWithPillNumber({
    required int pillNumberIntoPillSheet,
    required PillSheetGroup pillSheetGroup,
    required PillSheet pillSheet,
  }) async {
    if (pillNumberIntoPillSheet <= pillSheet.lastTakenPillNumber) {
      return false;
    }
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      return false;
    }
    if (activedPillSheet.activeRestDuration != null) {
      return false;
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    var diff = min(pillSheet.todayPillNumber, pillSheet.typeInfo.totalCount) - pillNumberIntoPillSheet;
    if (diff < 0) {
      // User tapped future pill number
      return false;
    }

    final takenDate = pillSheet.displayPillTakeDate(pillNumberIntoPillSheet);
    return _take(takenDate: takenDate, pillSheetGroup: pillSheetGroup);
  }

  Future<void> cancelTaken({required PillSheetGroup? pillSheetGroup}) async {
    if (pillSheetGroup == null) {
      throw const FormatException("現在有効なとなっているピルシートグループが見つかりませんでした");
    }
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("現在対象となっているピルシートが見つかりませんでした");
    }
    // キャンセルの場合は今日の服用のundo機能なので、服用済みじゃない場合はreturnする
    if (!activedPillSheet.todayPillIsAlreadyTaken || activedPillSheet.lastTakenDate == null) {
      return;
    }

    await revertTaken(
        pillSheetGroup: pillSheetGroup, pageIndex: activedPillSheet.groupIndex, pillNumberIntoPillSheet: activedPillSheet.lastTakenPillNumber);
  }

  Future<void> revertTaken({required PillSheetGroup pillSheetGroup, required int pageIndex, required int pillNumberIntoPillSheet}) async {
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("現在対象となっているピルシートが見つかりませんでした");
    }
    if (activedPillSheet.activeRestDuration != null) {
      throw const FormatException("ピルの服用の取り消し操作は休薬期間中は実行できません");
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];
    final takenDate = targetPillSheet.displayPillTakeDate(pillNumberIntoPillSheet).subtract(const Duration(days: 1)).date();

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      final lastTakenDate = pillSheet.lastTakenDate;
      if (lastTakenDate == null) {
        return pillSheet;
      }
      if (takenDate.isAfter(lastTakenDate)) {
        return pillSheet;
      }

      if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
        return pillSheet;
      }
      if (pillSheet.groupIndex < pageIndex) {
        return pillSheet;
      }

      if (takenDate.isBefore(pillSheet.beginingDate)) {
        // reset pill sheet when back to one before pill sheet
        return pillSheet.copyWith(lastTakenDate: pillSheet.beginingDate.subtract(const Duration(days: 1)).date(), restDurations: []);
      } else {
        // Revert対象の日付よりも後ろにある休薬期間のデータは消す
        final remainingResetDurations = pillSheet.restDurations.where((restDuration) => restDuration.beginDate.date().isBefore(takenDate)).toList();
        return pillSheet.copyWith(lastTakenDate: takenDate, restDurations: remainingResetDurations);
      }
    }).toList();

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where(
          (index) => pillSheetGroup.pillSheets[index] != updatedPillSheetGroup.pillSheets[index],
        );

    if (updatedIndexses.isEmpty) {
      return;
    }

    final batch = _batchFactory.batch();
    _pillSheetDatastore.update(
      batch,
      updatedPillSheets,
    );
    _pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.last];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.first];
    final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: before,
      after: after,
    );
    _pillSheetModifiedHistoryDatastore.add(batch, history);

    await batch.commit();
  }

  bool isDone({
    required int pillNumberIntoPillSheet,
    required PillSheetGroup? pillSheetGroup,
    required PillSheet pillSheet,
  }) {
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("pill sheet not found");
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activedPillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        if (pillNumberIntoPillSheet > pillSheet.lastTakenPillNumber) {
          return false;
        }
      }
      return true;
    }

    return pillNumberIntoPillSheet <= activedPillSheet.lastTakenPillNumber;
  }

  PillMarkType markFor({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) {
    if (pillNumberIntoPillSheet > pillSheet.typeInfo.dosingPeriod) {
      return (pillSheet.pillSheetType == PillSheetType.pillsheet_21 || pillSheet.pillSheetType == PillSheetType.pillsheet_24_rest_4)
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    if (pillNumberIntoPillSheet <= pillSheet.lastTakenPillNumber) {
      return PillMarkType.done;
    }
    if (pillNumberIntoPillSheet < pillSheet.todayPillNumber) {
      return PillMarkType.normal;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation({
    required int pillNumberIntoPillSheet,
    required PillSheetGroup? pillSheetGroup,
    required PillSheet pillSheet,
  }) {
    if (pillSheetGroup?.activedPillSheet?.activeRestDuration != null) {
      return false;
    }
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("pill sheet not found");
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activedPillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        if (pillNumberIntoPillSheet > pillSheet.lastTakenPillNumber) {
          return true;
        }
      }
      return false;
    }

    return pillNumberIntoPillSheet > activedPillSheet.lastTakenPillNumber && pillNumberIntoPillSheet <= activedPillSheet.todayPillNumber;
  }

  Future<void> beginRestDuration({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
  }) async {
    final restDuration = RestDuration(
      beginDate: now(),
      createdDate: now(),
    );
    final updatedPillSheet = activedPillSheet.copyWith(
      restDurations: activedPillSheet.restDurations..add(restDuration),
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);

    final batch = _batchFactory.batch();
    _pillSheetDatastore.update(batch, updatedPillSheetGroup.pillSheets);
    _pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);
    _pillSheetModifiedHistoryDatastore.add(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activedPillSheet,
        after: updatedPillSheet,
        restDuration: restDuration,
      ),
    );

    await batch.commit();
  }

  Future<void> endRestDuration({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required RestDuration restDuration,
  }) async {
    final updatedRestDuration = restDuration.copyWith(endDate: now());
    final updatedPillSheet = activedPillSheet.copyWith(
      restDurations: activedPillSheet.restDurations
        ..replaceRange(
          activedPillSheet.restDurations.length - 1,
          activedPillSheet.restDurations.length,
          [updatedRestDuration],
        ),
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);

    final batch = _batchFactory.batch();
    _pillSheetDatastore.update(batch, updatedPillSheetGroup.pillSheets);
    _pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);
    _pillSheetModifiedHistoryDatastore.add(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activedPillSheet,
        after: updatedPillSheet,
        restDuration: updatedRestDuration,
      ),
    );
    await batch.commit();
  }

  Future<void> setDisplayNumberSettingEndNumber({required int end, required PillSheetGroup pillSheetGroup}) async {
    final offsetPillNumber = pillSheetGroup.displayNumberSetting;
    final PillSheetGroup updatedPillSheetGroup;
    if (offsetPillNumber == null) {
      final newDisplayNumberSetting = DisplayNumberSetting(endPillNumber: end);
      updatedPillSheetGroup = pillSheetGroup.copyWith(displayNumberSetting: newDisplayNumberSetting);
    } else {
      final newDisplayNumberSetting = offsetPillNumber.copyWith(endPillNumber: end);
      updatedPillSheetGroup = pillSheetGroup.copyWith(displayNumberSetting: newDisplayNumberSetting);
    }

    _pillSheetGroupDatastore.update(updatedPillSheetGroup);
  }

  Future<void> switchingAppearanceMode({required PillSheetAppearanceMode mode, required Setting setting}) async {
    final updated = setting.copyWith(pillSheetAppearanceMode: mode);
    await _settingDatastore.update(updated);
  }
}

final recordPageAsyncActionProvider = Provider((ref) => RecordPageAsyncAction(
      ref.watch(batchFactoryProvider),
      ref.watch(pillSheetDatastoreProvider),
      ref.watch(settingDatastoreProvider),
      ref.watch(pillSheetModifiedHistoryDatastoreProvider),
      ref.watch(pillSheetGroupDatastoreProvider),
    ));
