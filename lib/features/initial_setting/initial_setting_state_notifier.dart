import 'dart:async';

import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:riverpod/riverpod.dart';

final initialSettingStateNotifierProvider = StateNotifierProvider.autoDispose<InitialSettingStateNotifier, InitialSettingState>(
  (ref) => InitialSettingStateNotifier(
    ref.watch(endInitialSettingProvider),
    ref.watch(batchFactoryProvider),
    ref.watch(batchSetSettingProvider),
    ref.watch(batchSetPillSheetModifiedHistoryProvider),
    ref.watch(batchSetPillSheetGroupProvider),
    ref.watch(registerReminderLocalNotificationRunnerProvider),
    now(),
  ),
);

class InitialSettingStateNotifier extends StateNotifier<InitialSettingState> {
  final EndInitialSetting endInitialSetting;
  final BatchFactory batchFactory;
  final BatchSetSetting batchSetSetting;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final RegisterReminderLocalNotificationRunner registerReminderLocalNotificationRunner;

  InitialSettingStateNotifier(
    this.endInitialSetting,
    this.batchFactory,
    this.batchSetSetting,
    this.batchSetPillSheetModifiedHistory,
    this.batchSetPillSheetGroup,
    this.registerReminderLocalNotificationRunner,
    DateTime _now,
  ) : super(
          InitialSettingState(
            reminderTimes: [
              ReminderTime(hour: _now.hour, minute: 0),
              ReminderTime(hour: _now.hour + 1, minute: 0),
            ],
          ),
        );

  void selectedFirstPillSheetType(PillSheetType pillSheetType) {
    state = state.copyWith(
      pillSheetTypes: [pillSheetType, pillSheetType, pillSheetType],
    );
  }

  void addPillSheetType(PillSheetType pillSheetType) {
    state = state.copyWith(
      pillSheetTypes: [...state.pillSheetTypes, pillSheetType],
    );
  }

  void changePillSheetType(int index, PillSheetType pillSheetType) {
    final copied = [...state.pillSheetTypes];
    copied[index] = pillSheetType;
    state = state.copyWith(pillSheetTypes: copied);
  }

  void removePillSheetType(index) {
    final copied = [...state.pillSheetTypes];
    copied.removeAt(index);
    state = state.copyWith(pillSheetTypes: copied);
  }

  void setReminderTime({
    required int index,
    required int hour,
    required int minute,
  }) {
    final copied = [...state.reminderTimes];
    if (index >= copied.length) {
      copied.add(ReminderTime(hour: hour, minute: minute));
    } else {
      copied[index] = ReminderTime(hour: hour, minute: minute);
    }
    state = state.copyWith(reminderTimes: copied);
  }

  void setTodayPillNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    state = state.copyWith(
      todayPillNumber: InitialSettingTodayPillNumber(
        pageIndex: pageIndex,
        pillNumberInPillSheet: pillNumberInPillSheet,
      ),
    );
  }

  void unsetTodayPillNumber() {
    state = state.copyWith(todayPillNumber: null);
  }

  void setPillTakenCount(int pillTakenCount) {
    state = state.copyWith(pillTakenCount: pillTakenCount);
  }

  /// 初期設定の内容を保存し、トライアルを開始する。
  /// トライアルは 1 アカウント 1 回のため、[user] が既にトライアルを開始している時は開始しない
  Future<void> register({required User user}) async {
    final batch = batchFactory.batch();

    final todayPillNumber = state.todayPillNumber;
    PillSheetGroup? createdPillSheetGroup;
    if (todayPillNumber != null) {
      final createdPillSheets = state.pillSheetTypes.asMap().keys.map((
        pageIndex,
      ) {
        return InitialSettingState.buildPillSheet(
          pageIndex: pageIndex,
          todayPillNumber: todayPillNumber,
          pillSheetTypes: state.pillSheetTypes,
          pillTakenCount: state.pillTakenCount,
        );
      }).toList();

      final pillSheetIDs = createdPillSheets.map((e) => e.id!).toList();
      createdPillSheetGroup = batchSetPillSheetGroup(
        batch,
        PillSheetGroup(
          pillTakenCount: state.pillTakenCount,
          pillSheetIDs: pillSheetIDs,
          pillSheets: createdPillSheets,
          createdAt: now(),
          // BEGIN: Release function for trial user
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          // END: Release function for trial user
        ),
      );

      final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
        beforePillSheetGroup: null,
        createdNewPillSheetGroup: createdPillSheetGroup,
      );
      batchSetPillSheetModifiedHistory(batch, history);
    }

    final setting = await state.buildSetting();
    batchSetSetting(batch, setting);

    await batch.commit();

    final activePillSheet = createdPillSheetGroup?.activePillSheet;
    if (createdPillSheetGroup != null && activePillSheet != null) {
      await registerReminderLocalNotificationRunner(
        createdPillSheetGroup: createdPillSheetGroup,
        activePillSheet: activePillSheet,
        premiumOrTrial: true,
        setting: setting,
      );
    }

    if (!user.trialIsAlreadyBegin) {
      await endInitialSetting();
    }
  }

  void showHUD() {
    state = state.copyWith(isLoading: true);
  }

  void hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}

final registerReminderLocalNotificationRunnerProvider = Provider(
  (ref) => RegisterReminderLocalNotificationRunner(),
);

// MockができないのでWrapperを作る
class RegisterReminderLocalNotificationRunner {
  Future<void> call({
    required PillSheetGroup createdPillSheetGroup,
    required PillSheet activePillSheet,
    required bool premiumOrTrial,
    required Setting setting,
  }) async {
    // 通知 ID は時刻と番号から決まり上書きされないため、初期設定をやり直した時に前回登録した通知が残らないよう全て解除してから登録する
    await CancelReminderLocalNotification()();
    await RegisterReminderLocalNotification.run(
      pillSheetGroup: createdPillSheetGroup,
      activePillSheet: activePillSheet,
      premiumOrTrial: true,
      setting: setting,
    );
  }
}
