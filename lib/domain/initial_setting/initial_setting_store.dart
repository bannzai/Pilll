import 'dart:async';

import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

final initialSettingStoreProvider = StateNotifierProvider(
  (ref) => InitialSettingStateStore(
    ref.watch(batchFactoryProvider),
    ref.watch(authServiceProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(pillSheetGroupServiceProvider),
  ),
);

class InitialSettingStateStore extends StateNotifier<InitialSettingState> {
  final BatchFactory _batchFactory;
  final AuthService _authService;
  final SettingService _settingService;
  final PillSheetService _pillSheetService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final PillSheetGroupService _pillSheetGroupService;
  InitialSettingStateStore(
    this._batchFactory,
    this._authService,
    this._settingService,
    this._pillSheetService,
    this._pillSheetModifiedHistoryService,
    this._pillSheetGroupService,
  ) : super(InitialSettingState()) {
    _reset();
  }

  _reset() {
    _subscribe();
  }

  StreamSubscription? _authCanceller;
  _subscribe() {
    _authCanceller?.cancel();
    _authCanceller = _authService.subscribe().listen((user) async {
      print(
          "watch sign state uid: ${user.uid}, isAnonymous: ${user.isAnonymous}");
      final isAccountCooperationDidEnd = !user.isAnonymous;
      if (isAccountCooperationDidEnd) {
        final userService = UserService(DatabaseConnection(user.uid));
        await userService.prepare(user.uid);
        await userService.recordUserIDs();
        errorLogger.setUserIdentifier(user.uid);
        firebaseAnalytics.setUserId(user.uid);
        await Purchases.identify(user.uid);
      }
      state = state.copyWith(
          isAccountCooperationDidEnd: isAccountCooperationDidEnd);
    });
  }

  void selectedPillSheetType(PillSheetType pillSheetType) {
    state = state.copyWith(pillSheetType: pillSheetType);
    if (state.fromMenstruation > pillSheetType.totalCount) {
      state = state.copyWith(fromMenstruation: pillSheetType.totalCount);
    }
  }

  void selectedPillSheetCount(int pillSheetCount) {
    state = state.copyWith(pillSheetCount: pillSheetCount);
  }

  void setReminderTime(int index, int hour, int minute) {
    final copied = [...state.reminderTimes];
    if (index >= copied.length) {
      copied.add(ReminderTime(hour: hour, minute: minute));
    } else {
      copied[index] = ReminderTime(hour: hour, minute: minute);
    }
    state = state.copyWith(reminderTimes: copied);
  }

  void setTodayPillNumber(int todayPillNumber) {
    state = state.copyWith(todayPillNumber: todayPillNumber);
  }

  void unsetTodayPillNumber() {
    state = state.copyWith(todayPillNumber: null);
  }

  void setFromMenstruation(int fromMenstruation) {
    state = state.copyWith(fromMenstruation: fromMenstruation);
  }

  void setDurationMenstruation(int durationMenstruation) {
    state = state.copyWith(durationMenstruation: durationMenstruation);
  }

  Future<void> register() async {
    final batch = _batchFactory.batch();

    _settingService.updateWithBatch(batch, state.buildSetting());

    final pillSheet = state.buildPillSheet();
    if (pillSheet != null) {
      final updatedPillSheet = _pillSheetService.register(batch, pillSheet);
      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
              before: null,
              pillSheetID: updatedPillSheet.id!,
              after: pillSheet);
      _pillSheetModifiedHistoryService.add(batch, history);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: [updatedPillSheet.id!],
        pillSheets: [updatedPillSheet],
      );
      _pillSheetGroupService.register(batch, pillSheetGroup);
    }

    await batch.commit();
  }

  Future<bool> canEndInitialSetting() async {
    try {
      await _settingService.fetch();
      return true;
    } catch (error) {
      return false;
    }
  }

  showHUD() {
    state = state.copyWith(isLoading: true);
  }

  hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}
