import 'dart:async';

import 'package:pilll/domain/record/record_page_async_action.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recordPageStoreProvider =
    StateNotifierProvider<RecordPageStore, AsyncValue<RecordPageState>>(
  (ref) => RecordPageStore(
    ref.watch(recordPageAsyncActionProvider),
    ref.watch(recordPageAsyncStateProvider),
  ),
);

class RecordPageStore extends StateNotifier<AsyncValue<RecordPageState>> {
  final RecordPageAsyncAction _asyncAction;
  RecordPageStore(
    this._asyncAction,
    AsyncValue<RecordPageState> _state,
  ) : super(_state);

  RecordPageState get _stateValue => state.value!;

  Future<bool> taken() =>
      _asyncAction.taken(pillSheetGroup: state.value?.pillSheetGroup);

  Future<bool> takenWithPillNumber({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) =>
      _asyncAction.takenWithPillNumber(
        pillNumberIntoPillSheet: pillNumberIntoPillSheet,
        pillSheetGroup: state.value?.pillSheetGroup,
        pillSheet: pillSheet,
      );

  Future<void> cancelTaken() async =>
      _asyncAction.cancelTaken(pillSheetGroup: state.value?.pillSheetGroup);

  Future<void> revertTaken({
    required PillSheetGroup pillSheetGroup,
    required int pageIndex,
    required int pillNumberIntoPillSheet,
  }) async =>
      _asyncAction.revertTaken(
        pillSheetGroup: pillSheetGroup,
        pageIndex: pageIndex,
        pillNumberIntoPillSheet: pillNumberIntoPillSheet,
      );

  bool isDone({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) {
    final activedPillSheet = state.value?.pillSheetGroup?.activedPillSheet;
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
      return (pillSheet.pillSheetType == PillSheetType.pillsheet_21 ||
              pillSheet.pillSheetType == PillSheetType.pillsheet_24_rest_4)
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
    required PillSheet pillSheet,
  }) {
    if (state.value?.pillSheetGroup?.activedPillSheet?.activeRestDuration !=
        null) {
      return false;
    }
    final activedPillSheet = state.value?.pillSheetGroup?.activedPillSheet;
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

    return pillNumberIntoPillSheet > activedPillSheet.lastTakenPillNumber &&
        pillNumberIntoPillSheet <= activedPillSheet.todayPillNumber;
  }

  void shownMigrateInfo() async {
    final value = state.value;
    if (value == null) {
      return;
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.migrateFrom132IsShown, true);

    state = AsyncValue.data(value.copyWith(shouldShowMigrateInfo: false));
  }

  Future<void> beginRestDuration({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
  }) async =>
      _asyncAction.beginRestDuration(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
      );

  Future<void> endRestDuration({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required RestDuration restDuration,
  }) async =>
      _asyncAction.endRestDuration(
          pillSheetGroup: pillSheetGroup,
          activedPillSheet: activedPillSheet,
          restDuration: restDuration);

  void setDisplayNumberSettingBeginNumber(int begin) =>
      _asyncAction.setDisplayNumberSettingBeginNumber(
          begin: begin, pillSheetGroup: state.value?.pillSheetGroup);

  Future<void> setDisplayNumberSettingEndNumber(int end) async =>
      _asyncAction.setDisplayNumberSettingEndNumber(
          end: end, pillSheetGroup: state.value?.pillSheetGroup);

  void switchingAppearanceMode(PillSheetAppearanceMode mode) => _asyncAction
      .switchingAppearanceMode(mode: mode, setting: _stateValue.setting);

  void setTrueIsAlreadyShowPremiumFunctionSurvey() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.isAlreadyShowPremiumSurvey, true);

    state =
        AsyncValue.data(_stateValue.copyWith(isAlreadyShowPremiumSurvey: true));
  }
}
