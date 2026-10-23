import 'dart:async';

import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
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
    ref.watch(remoteConfigParameterProvider),
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
  final RemoteConfigParameter remoteConfigParameter;
  final RegisterReminderLocalNotificationRunner registerReminderLocalNotificationRunner;

  InitialSettingStateNotifier(
    this.endInitialSetting,
    this.batchFactory,
    this.batchSetSetting,
    this.batchSetPillSheetModifiedHistory,
    this.batchSetPillSheetGroup,
    this.remoteConfigParameter,
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
  /// ピルシートは28錠タイプ固定で、枚数はヤーズフレックス以外の初期設定の既定と同じ3枚にする
  void selectYazFlex() {
    state = state.copyWith(
      isYazFlex: true,
      pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0],
      todayPillNumber: null,
      yazFlexHasNotRestedYet: false,
      yazFlexLastRestDurationBeginDate: null,
      yazFlexLastRestDurationEndDate: null,
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
      yazFlexLastRestDurationBeginDate: null,
      yazFlexLastRestDurationEndDate: null,
      yazFlexBeginPillNumber: 1,
    );
  }

  /// ヤーズフレックス向けの導線で前回の休薬の入力をスキップする (true)・入力して進む (false)。スキップした時は入力済みの休薬の日付を消す
  void setYazFlexHasNotRestedYet({required bool yazFlexHasNotRestedYet}) {
    state = state.copyWith(
      yazFlexHasNotRestedYet: yazFlexHasNotRestedYet,
      yazFlexLastRestDurationBeginDate: yazFlexHasNotRestedYet ? null : state.yazFlexLastRestDurationBeginDate,
      yazFlexLastRestDurationEndDate: yazFlexHasNotRestedYet ? null : state.yazFlexLastRestDurationEndDate,
    );
  }

  /// ヤーズフレックス向けの導線で入力した前回の休薬の開始日と服用を再開した日を消す (開始日の × を押した時)
  void clearYazFlexLastRestDuration() {
    state = state.copyWith(
      yazFlexLastRestDurationBeginDate: null,
      yazFlexLastRestDurationEndDate: null,
    );
  }

  /// ヤーズフレックス向けの導線で入力した服用を再開した日だけを消し、休薬中 (まだ再開していない) の入力にする
  void clearYazFlexLastRestDurationEndDate() {
    state = state.copyWith(yazFlexLastRestDurationEndDate: null);
  }

  /// ヤーズフレックス向けの導線で前回の休薬が始まった日を入力する
  /// 終わった日が始まった日以前になる時は、終わった日を未入力に戻す。スキップした後に戻って入力し直した時はスキップを解除し、プレビューに反映する
  void setYazFlexLastRestDurationBeginDate({required DateTime yazFlexLastRestDurationBeginDate}) {
    final yazFlexLastRestDurationEndDate = state.yazFlexLastRestDurationEndDate;
    state = state.copyWith(
      yazFlexHasNotRestedYet: false,
      yazFlexLastRestDurationBeginDate: yazFlexLastRestDurationBeginDate,
      yazFlexLastRestDurationEndDate:
          yazFlexLastRestDurationEndDate != null && yazFlexLastRestDurationEndDate.isAfter(yazFlexLastRestDurationBeginDate)
              ? yazFlexLastRestDurationEndDate
              : null,
    );
  }

  /// ヤーズフレックス向けの導線で前回の休薬が終わった日 (服用を再開した日) を入力する。スキップした後に戻って入力し直した時はスキップを解除する
  void setYazFlexLastRestDurationEndDate({required DateTime yazFlexLastRestDurationEndDate}) {
    state = state.copyWith(
      yazFlexHasNotRestedYet: false,
      yazFlexLastRestDurationEndDate: yazFlexLastRestDurationEndDate,
    );
  }

  /// ヤーズフレックス向けの導線で開始番号 (1枚目の1番は休薬明けから何日目か) を入力する
  void setYazFlexBeginPillNumber({required int yazFlexBeginPillNumber}) {
    state = state.copyWith(yazFlexBeginPillNumber: yazFlexBeginPillNumber);
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

  Future<void> register() async {
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

    await endInitialSetting(remoteConfigParameter);
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
    await RegisterReminderLocalNotification.run(
      pillSheetGroup: createdPillSheetGroup,
      activePillSheet: activePillSheet,
      premiumOrTrial: true,
      setting: setting,
    );
  }
}
