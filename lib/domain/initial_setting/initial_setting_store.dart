import 'dart:async';

import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
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
    state = state.copyWith(pillSheetTypes: [pillSheetType]);
    state = state.copyWith(menstruations: [
      MenstruationSetting(
          pillNumberForFromMenstruation: 0, durationMenstruation: 0)
    ]);
    final todayPillNumber = state.sequentialTodayPillNumber;
    if (todayPillNumber != null &&
        todayPillNumber > state.pillSheetTypes.first.totalCount) {
      state = state.copyWith(
          sequentialTodayPillNumber: state.pillSheetTypes.first.totalCount);
    }
  }

  void addPillSheetType(PillSheetType pillSheetType) {
    state = state.copyWith(
        pillSheetTypes: [...state.pillSheetTypes]..add(pillSheetType));
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

  void setReminderTime(int index, int hour, int minute) {
    final copied = [...state.reminderTimes];
    if (index >= copied.length) {
      copied.add(ReminderTime(hour: hour, minute: minute));
    } else {
      copied[index] = ReminderTime(hour: hour, minute: minute);
    }
    state = state.copyWith(reminderTimes: copied);
  }

  void setTodayPillNumber(int sequentialTodayPillNumber) {
    state =
        state.copyWith(sequentialTodayPillNumber: sequentialTodayPillNumber);
  }

  void unsetTodayPillNumber() {
    state = state.copyWith(sequentialTodayPillNumber: null);
  }

  setCurrentMenstruationPageIndex(int pageIndex) {
    state = state.copyWith(currentMenstruationPageIndex: pageIndex);
  }

  void setFromMenstruation({
    required int pageIndex,
    required int fromMenstruation,
  }) {
    if (state.menstruations.length < pageIndex) {
      state.copyWith(
          menstruations: state.menstruations
            ..add(MenstruationSetting(
                pillNumberForFromMenstruation: fromMenstruation,
                durationMenstruation: 0)));
    }
    final copiedMenstruations = [...state.menstruations];
    final menstruation = copiedMenstruations[pageIndex];
    final updatedMenstruation =
        menstruation.copyWith(pillNumberForFromMenstruation: fromMenstruation);
    copiedMenstruations[pageIndex] = updatedMenstruation;
    state.copyWith(menstruations: copiedMenstruations);
  }

  void setDurationMenstruation({
    required int pageIndex,
    required int durationMenstruation,
  }) {
    if (state.menstruations.length < pageIndex) {
      state.copyWith(
          menstruations: state.menstruations
            ..add(MenstruationSetting(
                pillNumberForFromMenstruation: 0,
                durationMenstruation: durationMenstruation)));
    }
    final copiedMenstruations = [...state.menstruations];
    final menstruation = copiedMenstruations[pageIndex];
    final updatedMenstruation =
        menstruation.copyWith(durationMenstruation: durationMenstruation);
    copiedMenstruations[pageIndex] = updatedMenstruation;
    state.copyWith(menstruations: copiedMenstruations);
  }

  Future<void> register() async {
    if (state.pillSheetTypes.isEmpty) {
      throw AssertionError(
          "Must not be null for pillSheet when register initial settings");
    }

    final batch = _batchFactory.batch();

    _settingService.updateWithBatch(batch, state.buildSetting());

    final sequentialTodayPillNumber = state.sequentialTodayPillNumber;
    if (sequentialTodayPillNumber != null) {
      final Map<String, PillSheet> idAndPillSheet = {};

      var i = 0;
      state.pillSheetTypes.forEach((pillSheetType) {
        final pillSheet = state.buildPillSheet(
          pageIndex: i,
          sequentialTodayPillNumber: sequentialTodayPillNumber,
          pillSheetTypes: state.pillSheetTypes,
        );
        final createdPillSheet = _pillSheetService.register(batch, pillSheet);

        final pillSheetID = createdPillSheet.id!;
        idAndPillSheet[pillSheetID] = createdPillSheet;

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createCreatedPillSheetAction(
                before: null,
                pillSheetID: createdPillSheet.id!,
                after: pillSheet);
        _pillSheetModifiedHistoryService.add(batch, history);

        i += 1;
      });

      final pillSheetIDs = idAndPillSheet.keys.toList();
      final pillSheets = idAndPillSheet.values.toList();
      final pillSheetGroup =
          PillSheetGroup(pillSheetIDs: pillSheetIDs, pillSheets: pillSheets);
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
