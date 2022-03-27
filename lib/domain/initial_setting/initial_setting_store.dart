import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/initial_setting_pill_category_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

final initialSettingStoreProvider = StateNotifierProvider.autoDispose<
    InitialSettingStateStore, InitialSettingState>(
  (ref) => InitialSettingStateStore(
    ref.watch(userServiceProvider),
    ref.watch(batchFactoryProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(pillSheetGroupServiceProvider),
    ref.watch(authServiceProvider),
  ),
);

final initialSettingStateProvider =
    StateProvider.autoDispose((ref) => ref.watch(initialSettingStoreProvider));

class InitialSettingStateStore extends StateNotifier<InitialSettingState> {
  final UserService _userService;
  final BatchFactory _batchFactory;
  final SettingService _settingService;
  final PillSheetService _pillSheetService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final PillSheetGroupService _pillSheetGroupService;
  final AuthService _authService;

  InitialSettingStateStore(
    this._userService,
    this._batchFactory,
    this._settingService,
    this._pillSheetService,
    this._pillSheetModifiedHistoryService,
    this._pillSheetGroupService,
    this._authService,
  ) : super(const InitialSettingState());

  StreamSubscription? _authServiceCanceller;
  fetch() {
    _authServiceCanceller = _authService.stream().listen((user) async {
      print("watch sign state user: $user");

      final userIsNotAnonymous = !user.isAnonymous;
      if (userIsNotAnonymous) {
        final userService = UserService(DatabaseConnection(user.uid));
        final dbUser = await userService.prepare(user.uid);
        userService.saveUserLaunchInfo();

        unawaited(FirebaseCrashlytics.instance.setUserIdentifier(user.uid));
        unawaited(firebaseAnalytics.setUserId(id: user.uid));
        await Purchases.logIn(user.uid);

        state = state.copyWith(userIsNotAnonymous: userIsNotAnonymous);
        state = state.copyWith(settingIsExist: dbUser.setting != null);
        if (isLinkedApple()) {
          state = state.copyWith(accountType: LinkAccountType.apple);
        } else if (isLinkedGoogle()) {
          state = state.copyWith(accountType: LinkAccountType.google);
        }
      }

      _authServiceCanceller?.cancel();
    });
  }

  void selectedPillCategoryType(
      InitialSettingPillCategoryType pillCategoryType) {
    state = state.copyWith(pillType: pillCategoryType);
    state = state.copyWith(todayPillNumber: null);

    switch (pillCategoryType) {
      case InitialSettingPillCategoryType.pill_category_type_yaz_flex:
        state = state.copyWith(
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_28_0,
          ],
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        break;
      case InitialSettingPillCategoryType.pill_category_type_jemina:
        state = state.copyWith(
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        break;
      case InitialSettingPillCategoryType.pill_category_type_21_rest_7:
        state = state.copyWith(
          pillSheetTypes: [
            PillSheetType.pillsheet_21,
            PillSheetType.pillsheet_21,
            PillSheetType.pillsheet_21,
          ],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        break;
      case InitialSettingPillCategoryType.pill_category_type_24_fake_4:
        state = state.copyWith(
          pillSheetTypes: [
            PillSheetType.pillsheet_28_4,
            PillSheetType.pillsheet_28_4,
            PillSheetType.pillsheet_28_4,
          ],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        break;
      case InitialSettingPillCategoryType.pill_category_type_24_rest_4:
        state = state.copyWith(
          pillSheetTypes: [
            PillSheetType.pillsheet_24_rest_4,
            PillSheetType.pillsheet_24_rest_4,
            PillSheetType.pillsheet_24_rest_4,
          ],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        break;
      case InitialSettingPillCategoryType.pill_category_type_21_fake_7:
        state = state.copyWith(
          pillSheetTypes: [
            PillSheetType.pillsheet_28_7,
            PillSheetType.pillsheet_28_7,
            PillSheetType.pillsheet_28_7,
          ],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        break;
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
    required int pillNumberIntoPillSheet,
  }) {
    state = state.copyWith(
      todayPillNumber: InitialSettingTodayPillNumber(
        pageIndex: pageIndex,
        pillNumberIntoPillSheet: pillNumberIntoPillSheet,
      ),
    );
  }

  void unsetTodayPillNumber() {
    state = state.copyWith(todayPillNumber: null);
  }

  Future<void> register() async {
    if (state.pillSheetTypes.isEmpty) {
      throw AssertionError(
          "Must not be null for pillSheet when register initial settings");
    }

    final batch = _batchFactory.batch();

    final todayPillNumber = state.todayPillNumber;
    if (todayPillNumber != null) {
      final createdPillSheets = _pillSheetService.register(
        batch,
        state.pillSheetTypes.asMap().keys.map((pageIndex) {
          return InitialSettingState.buildPillSheet(
            pageIndex: pageIndex,
            todayPillNumber: todayPillNumber,
            pillSheetTypes: state.pillSheetTypes,
          );
        }).toList(),
      );

      final pillSheetIDs = createdPillSheets.map((e) => e.id!).toList();
      final createdPillSheetGroup = _pillSheetGroupService.register(
        batch,
        PillSheetGroup(
          pillSheetIDs: pillSheetIDs,
          pillSheets: createdPillSheets,
          createdAt: now(),
        ),
      );

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
        pillSheetIDs: pillSheetIDs,
        pillSheetGroupID: createdPillSheetGroup.id,
      );
      _pillSheetModifiedHistoryService.add(batch, history);
    }

    final setting = state.buildSetting();
    _settingService.updateWithBatch(batch, setting);

    await batch.commit();

    await _userService.trial(setting);
  }

  showHUD() {
    state = state.copyWith(isLoading: true);
  }

  hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}
