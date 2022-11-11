import 'dart:async';

import 'package:pilll/domain/record/record_page_async_action.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recordPageStateNotifierProvider = StateNotifierProvider.autoDispose<RecordPageStateNotifier, AsyncValue<RecordPageState>>(
  (ref) => RecordPageStateNotifier(
    asyncAction: ref.watch(recordPageAsyncActionProvider),
    initialState: ref.watch(recordPageAsyncStateProvider),
  ),
);

class RecordPageStateNotifier extends StateNotifier<AsyncValue<RecordPageState>> {
  final RecordPageAsyncAction asyncAction;
  RecordPageStateNotifier({
    required this.asyncAction,
    required AsyncValue<RecordPageState> initialState,
  }) : super(initialState);

  RecordPageState get _stateValue => state.value!;

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

  void showMigrateInfo() async {
    final value = state.value;
    if (value == null) {
      return;
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.migrateFrom132IsShown, true);

    state = AsyncValue.data(value.copyWith(shouldShowMigrateInfo: false));
  }

  Future<void> setTrueIsAlreadyShowPremiumFunctionSurvey() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.isAlreadyShowPremiumSurvey, true);

    state = AsyncValue.data(_stateValue.copyWith(isAlreadyShowPremiumSurvey: true));
  }
}

bool shouldPillMarkAnimation({
  required int pillNumberIntoPillSheet,
  required PillSheet pillSheet,
  required PillSheetGroup pillSheetGroup,
}) {
  if (pillSheetGroup.activedPillSheet?.activeRestDuration != null) {
    return false;
  }
  final activedPillSheet = pillSheetGroup.activedPillSheet;
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
