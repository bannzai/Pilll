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

  /// 「ヤーズフレックスの方ですか？」に「はい」と答えた時の状態にする
  /// ピルシートは28錠タイプ固定で 5 枚。ヤーズフレックスの連続服用は最長 120 日 (28錠 × 4 枚 + 8 錠) なので、1 周期を 1 つのピルシートグループに収めるには 5 枚要る
  void selectYazFlex() {
    state = state.copyWith(
      isYazFlex: true,
      pillSheetTypes: List.filled(5, PillSheetType.pillsheet_28_0),
      todayPillNumber: null,
      yazFlexHasNotRestedYet: false,
      yazFlexLastTakenPillNumberBeforeRest: null,
      yazFlexIsResting: false,
      yazFlexRestDurationDays: 4,
      yazFlexBeginPillNumber: 1,
    );
  }

  /// 「ヤーズフレックスの方ですか？」に「いいえ」と答えた時の状態にする
  /// 一度「はい」を選んでから戻った場合は、ピルシートの種類の選択から始まる従来の導線と同じ状態に戻す
  /// 「いいえ」から戻って再度「いいえ」を選んだ場合は、選択済みのピルシートの種類と今日の番号を残す
  void selectNotYazFlex() {
    if (!state.isYazFlex) {
      return;
    }
    state = state.copyWith(
      isYazFlex: false,
      pillSheetTypes: [],
      todayPillNumber: null,
      yazFlexHasNotRestedYet: false,
      yazFlexLastTakenPillNumberBeforeRest: null,
      yazFlexIsResting: false,
      yazFlexRestDurationDays: 4,
      yazFlexBeginPillNumber: 1,
    );
  }

  /// ヤーズフレックス向けの導線で前回の休薬の入力をスキップする (true)・入力して進む (false)。スキップした時は選んだ休薬のピルと休薬中の入力を消す
  void setYazFlexHasNotRestedYet({required bool yazFlexHasNotRestedYet}) {
    state = state.copyWith(
      yazFlexHasNotRestedYet: yazFlexHasNotRestedYet,
      yazFlexLastTakenPillNumberBeforeRest: yazFlexHasNotRestedYet ? null : state.yazFlexLastTakenPillNumberBeforeRest,
      yazFlexIsResting: yazFlexHasNotRestedYet ? false : state.yazFlexIsResting,
    );
  }

  /// ヤーズフレックス向けの導線で「休薬中でまだ服用を再開していない」を切り替える
  /// 休薬中にすると、休薬のピルは今日飲む番号のピルの 1 つ前に決まるのでタップで選んだピルを消し、スキップも解除する
  void setYazFlexIsResting({required bool yazFlexIsResting}) {
    state = state.copyWith(
      yazFlexIsResting: yazFlexIsResting,
      yazFlexHasNotRestedYet: false,
      yazFlexLastTakenPillNumberBeforeRest: yazFlexIsResting ? null : state.yazFlexLastTakenPillNumberBeforeRest,
    );
  }

  /// ヤーズフレックス向けの導線で休薬に入る直前に飲んだピルをタップで選ぶ。今日飲む番号のピル以降は選べないので無視する
  /// 休薬中 (まだ再開していない) の時は休薬のピルが今日のピルの 1 つ前に決まるので無視する
  /// スキップした後に戻って選び直した時はスキップを解除し、プレビューに反映する
  void setYazFlexLastTakenPillNumberBeforeRest({required int pageIndex, required int pillNumberInPillSheet}) {
    if (state.yazFlexIsResting ||
        !state.yazFlexCanSelectAsLastTakenPillBeforeRest(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet)) {
      return;
    }
    state = state.copyWith(
      yazFlexHasNotRestedYet: false,
      yazFlexLastTakenPillNumberBeforeRest: InitialSettingTodayPillNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
    );
  }

  /// ヤーズフレックス向けの導線で前回の休薬の日数を入力する
  void setYazFlexRestDurationDays({required int yazFlexRestDurationDays}) {
    state = state.copyWith(yazFlexRestDurationDays: yazFlexRestDurationDays);
  }

  /// ヤーズフレックス向けの導線で開始番号 (1枚目の1番は休薬明けから何日目か) を入力する
  void setYazFlexBeginPillNumber({required int yazFlexBeginPillNumber}) {
    state = state.copyWith(yazFlexBeginPillNumber: yazFlexBeginPillNumber);
  }

  /// 今日飲む番号を選ぶ。ヤーズフレックス向けの導線で選んだ休薬のピルが今日のピル以降になる時 (戻って今日の番号を変えた時) は、その選択を消す
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
    final lastTakenPillNumberBeforeRest = state.yazFlexLastTakenPillNumberBeforeRest;
    if (lastTakenPillNumberBeforeRest != null &&
        !state.yazFlexCanSelectAsLastTakenPillBeforeRest(
          pageIndex: lastTakenPillNumberBeforeRest.pageIndex,
          pillNumberInPillSheet: lastTakenPillNumberBeforeRest.pillNumberInPillSheet,
        )) {
      state = state.copyWith(yazFlexLastTakenPillNumberBeforeRest: null);
    }
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

    final builtPillSheetGroup = state.buildPillSheetGroup();
    PillSheetGroup? createdPillSheetGroup;
    if (builtPillSheetGroup != null) {
      createdPillSheetGroup = batchSetPillSheetGroup(batch, builtPillSheetGroup);

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
