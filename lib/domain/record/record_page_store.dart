import 'dart:io' show Platform;
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recordPageStoreProvider = StateNotifierProvider((ref) => RecordPageStore(
      ref.watch(batchFactoryProvider),
      ref.watch(pillSheetServiceProvider),
      ref.watch(settingServiceProvider),
      ref.watch(userServiceProvider),
      ref.watch(authServiceProvider),
      ref.watch(pillSheetModifiedHistoryServiceProvider),
      ref.watch(pillSheetGroupServiceProvider),
    ));

class RecordPageStore extends StateNotifier<RecordPageState> {
  final BatchFactory _batchFactory;
  final PillSheetService _pillSheetService;
  final SettingService _settingService;
  final UserService _userService;
  final AuthService _authService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final PillSheetGroupService _pillSheetGroupService;
  RecordPageStore(
    this._batchFactory,
    this._pillSheetService,
    this._settingService,
    this._userService,
    this._authService,
    this._pillSheetModifiedHistoryService,
    this._pillSheetGroupService,
  ) : super(RecordPageState()) {
    reset();
  }

  void reset() {
    Future(() async {
      final pillSheetGroup = await _pillSheetGroupService.fetchLatest();
      final setting = await _settingService.fetch();
      final sharedPreferences = await SharedPreferences.getInstance();
      final user = await _userService.fetch();
      final totalCountOfActionForTakenPill =
          sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0;
      final shouldShowMigrateInfo = () {
        if (!Platform.isIOS) {
          return false;
        }
        if (sharedPreferences.getBool(BoolKey.migrateFrom132IsShown) ?? false) {
          return false;
        }
        if (!sharedPreferences
            .containsKey(StringKey.salvagedOldStartTakenDate)) {
          return false;
        }
        if (!sharedPreferences
            .containsKey(StringKey.salvagedOldLastTakenDate)) {
          return false;
        }
        return true;
      }();
      final recommendedSignupNotificationIsAlreadyShow = sharedPreferences
              .getBool(BoolKey.recommendedSignupNotificationIsAlreadyShow) ??
          false;
      final premiumTrialGuideNotificationIsClosed = sharedPreferences
              .getBool(BoolKey.premiumTrialGuideNotificationIsClosed) ??
          false;
      state = RecordPageState(
        pillSheetGroup: pillSheetGroup,
        setting: setting,
        firstLoadIsEnded: true,
        totalCountOfActionForTakenPill: totalCountOfActionForTakenPill,
        exception: null,
        isAlreadyShowTiral:
            sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumTrialModal) ??
                false,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        hasDiscountEntitlement: user.hasDiscountEntitlement,
        discountEntitlementDeadlineDate: user.discountEntitlementDeadlineDate,
        shouldShowMigrateInfo: shouldShowMigrateInfo,
        isLinkedLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
        recommendedSignupNotificationIsAlreadyShow:
            recommendedSignupNotificationIsAlreadyShow,
        premiumTrialGuideNotificationIsClosed:
            premiumTrialGuideNotificationIsClosed,
      );
      _subscribe();
    });
  }

  StreamSubscription? _pillSheetGroupCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _userSubscribeCanceller;
  StreamSubscription? _authServiceCanceller;
  void _subscribe() {
    _pillSheetGroupCanceller?.cancel();
    _pillSheetGroupCanceller =
        _pillSheetGroupService.subscribeForLatest().listen((event) {
      state = state.copyWith(pillSheetGroup: event);
    });
    _settingCanceller?.cancel();
    _settingCanceller = _settingService.subscribe().listen((setting) {
      state = state.copyWith(setting: setting);
    });
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        hasDiscountEntitlement: event.hasDiscountEntitlement,
        trialDeadlineDate: event.trialDeadlineDate,
        discountEntitlementDeadlineDate: event.discountEntitlementDeadlineDate,
      );
    });
    _authServiceCanceller?.cancel();
    _authServiceCanceller = _authService.subscribe().listen((event) {
      state = state.copyWith(
          isLinkedLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
  }

  @override
  void dispose() {
    _pillSheetGroupCanceller?.cancel();
    _settingCanceller?.cancel();
    _userSubscribeCanceller?.cancel();
    _authServiceCanceller?.cancel();
    super.dispose();
  }

  Future<void> register(PillSheet model) async {
    final batch = _batchFactory.batch();

    final documentID = _pillSheetService.register(batch, model);
    final history = PillSheetModifiedHistoryServiceActionFactory
        .createCreatedPillSheetAction(
            before: null, pillSheetID: documentID, after: model);
    _pillSheetModifiedHistoryService.add(batch, history);

    return batch.commit();
  }

  Future<dynamic>? _take(DateTime takenDate) async {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException("active pill sheet not found");
    }
    if (activePillSheet.todayPillNumber ==
        activePillSheet.lastTakenPillNumber) {
      return null;
    }

    FlutterAppBadger.removeBadge();

    final batch = _batchFactory.batch();

    final updatedPillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);
    _pillSheetService.update(batch, updatedPillSheet);

    final history =
        PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            before: activePillSheet, after: updatedPillSheet);
    _pillSheetModifiedHistoryService.add(batch, history);

    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    _pillSheetGroupService.update(batch, updatedPillSheetGroup);

    await batch.commit();
    state = state.copyWith(pillSheetGroup: updatedPillSheetGroup);
  }

  Future<void>? taken() {
    return _take(now());
  }

  Future<void>? takenWithPillNumber(int pillNumber) async {
    final pillSheet = state.pillSheetGroup?.activePillSheet;
    if (pillSheet == null) {
      return null;
    }
    if (pillNumber <= pillSheet.lastTakenPillNumber) {
      return null;
    }
    var diff = pillSheet.todayPillNumber - pillNumber;
    if (diff < 0) {
      // This is in the future pill number.
      return null;
    }
    var takenDate = now().subtract(Duration(days: diff));
    return _take(takenDate);
  }

  Future<void> cancelTaken() async {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException("active pill sheet not found");
    }
    if (activePillSheet.todayPillNumber !=
        activePillSheet.lastTakenPillNumber) {
      return;
    }
    final lastTakenDate = activePillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      return;
    }

    final batch = _batchFactory.batch();

    final updatedPillSheet = activePillSheet.copyWith(
        lastTakenDate: lastTakenDate.subtract(Duration(days: 1)));
    _pillSheetService.update(batch, updatedPillSheet);

    final history = PillSheetModifiedHistoryServiceActionFactory
        .createRevertTakenPillAction(
            before: activePillSheet, after: updatedPillSheet);
    _pillSheetModifiedHistoryService.add(batch, history);

    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    _pillSheetGroupService.update(batch, updatedPillSheetGroup);

    await batch.commit();
    state = state.copyWith(pillSheetGroup: updatedPillSheetGroup);
  }

  DateTime calcBeginingDateFromNextTodayPillNumber(int pillNumber) {
    final entity = state.pillSheetGroup?.activePillSheet;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    return calcBeginingDateFromNextTodayPillNumberFunction(entity, pillNumber);
  }

  Future<void> modifyBeginingDate(int pillNumber) async {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException("active pill sheet not found");
    }

    final batch = _batchFactory.batch();
    final updated = modifyBeginingDateFunction(
      batch,
      _pillSheetService,
      _pillSheetModifiedHistoryService,
      _pillSheetGroupService,
      activePillSheet,
      pillSheetGroup,
      pillNumber,
    );
    await batch.commit();

    state = state.copyWith(pillSheetGroup: updated);
  }

  PillMarkType markFor(int number) {
    final activePillSheet = state.pillSheetGroup?.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException("pill sheet not found");
    }
    if (number > activePillSheet.typeInfo.dosingPeriod) {
      return activePillSheet.pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    if (number <= activePillSheet.lastTakenPillNumber) {
      return PillMarkType.done;
    }
    if (number < activePillSheet.todayPillNumber) {
      return PillMarkType.normal;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation(int number) {
    final activePillSheet = state.pillSheetGroup?.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException("pill sheet not found");
    }
    return number > activePillSheet.lastTakenPillNumber &&
        number <= activePillSheet.todayPillNumber;
  }

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  shownMigrateInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.migrateFrom132IsShown, true);
    state = state.copyWith(shouldShowMigrateInfo: false);
  }
}

PillSheetGroup modifyBeginingDateFunction(
  WriteBatch batch,
  PillSheetService service,
  PillSheetModifiedHistoryService pillSheetModifiedHistoryService,
  PillSheetGroupService pillSheetGroupService,
  PillSheet pillSheet,
  PillSheetGroup pillSheetGroup,
  int pillNumber,
) {
  final updatedPillSheet = pillSheet.copyWith(
    beginingDate: calcBeginingDateFromNextTodayPillNumberFunction(
      pillSheet,
      pillNumber,
    ),
  );
  service.update(
    batch,
    updatedPillSheet,
  );

  final history = PillSheetModifiedHistoryServiceActionFactory
      .createChangedPillNumberAction(
          before: pillSheet, after: updatedPillSheet);
  pillSheetModifiedHistoryService.add(batch, history);

  final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
  pillSheetGroupService.update(batch, updatedPillSheetGroup);

  return updatedPillSheetGroup;
}

DateTime calcBeginingDateFromNextTodayPillNumberFunction(
  PillSheet pillSheet,
  int pillNumber,
) {
  if (pillNumber == pillSheet.todayPillNumber) return pillSheet.beginingDate;
  final diff = pillNumber - pillSheet.todayPillNumber;
  return pillSheet.beginingDate.subtract(Duration(days: diff));
}
