import 'dart:io' show Platform;
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
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
    ));

class RecordPageStore extends StateNotifier<RecordPageState> {
  final BatchFactory _batchFactory;
  final PillSheetService _service;
  final SettingService _settingService;
  final UserService _userService;
  final AuthService _authService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  RecordPageStore(
    this._batchFactory,
    this._service,
    this._settingService,
    this._userService,
    this._authService,
    this._pillSheetModifiedHistoryService,
  ) : super(RecordPageState(entity: null)) {
    reset();
  }

  void reset() {
    Future(() async {
      final entity = await _service.fetchLast();
      final entities = await _service.fetchListWithMax(2);
      final isPillSheetFinishedInThePast =
          entities.where((element) => element.id != entity?.id).length >= 1;
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
        entity: entity,
        setting: setting,
        firstLoadIsEnded: true,
        totalCountOfActionForTakenPill: totalCountOfActionForTakenPill,
        exception: null,
        isPillSheetFinishedInThePast: isPillSheetFinishedInThePast,
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
      if (entity != null) {
        analytics.logEvent(name: "count_of_remaining_pill", parameters: {
          "count": (entity.todayPillNumber - entity.lastTakenPillNumber)
        });
      }
      _subscribe();
    });
  }

  StreamSubscription<PillSheet>? _canceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _userSubscribeCanceller;
  StreamSubscription? _authServiceCanceller;
  void _subscribe() {
    _canceller?.cancel();
    _canceller = _service.subscribeForLatestPillSheet().listen((event) {
      state = state.copyWith(entity: event);
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
    _canceller?.cancel();
    _settingCanceller?.cancel();
    _userSubscribeCanceller?.cancel();
    _authServiceCanceller?.cancel();
    super.dispose();
  }

  Future<void> register(PillSheet model) async {
    final batch = _batchFactory.batch();

    final history = PillSheetModifiedHistoryServiceActionFactory
        .createCreatedPillSheetAction(before: null, after: model);
    _pillSheetModifiedHistoryService.add(batch, history);
    _service.register(batch, model);

    return batch.commit();
  }

  Future<dynamic>? _take(DateTime takenDate) async {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    if (entity.todayPillNumber == entity.lastTakenPillNumber) {
      return null;
    }

    FlutterAppBadger.removeBadge();

    final batch = _batchFactory.batch();

    final updated = entity.copyWith(lastTakenDate: takenDate);
    _service.update(batch, updated);

    final history =
        PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            before: entity, after: updated);
    _pillSheetModifiedHistoryService.add(batch, history);

    await batch.commit();
    state = state.copyWith(entity: updated);
  }

  Future<void>? taken() {
    return _take(now());
  }

  Future<void>? takenWithPillNumber(int pillNumber) async {
    final pillSheet = state.entity;
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
    final pillSheet = state.entity;
    if (pillSheet == null) {
      return;
    }
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      return;
    }
    final lastTakenDate = pillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      return;
    }

    final batch = _batchFactory.batch();

    final updated = pillSheet.copyWith(
        lastTakenDate: lastTakenDate.subtract(Duration(days: 1)));
    _service.update(batch, updated);

    final history = PillSheetModifiedHistoryServiceActionFactory
        .createRevertTakenPillAction(before: pillSheet, after: updated);
    _pillSheetModifiedHistoryService.add(batch, history);

    await batch.commit();
  }

  DateTime calcBeginingDateFromNextTodayPillNumber(int pillNumber) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    return calcBeginingDateFromNextTodayPillNumberFunction(entity, pillNumber);
  }

  void modifyBeginingDate(int pillNumber) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }

    modifyBeginingDateFunction(_service, entity, pillNumber)
        .then((entity) => state = state.copyWith(entity: entity));
  }

  PillMarkType markFor(int number) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    if (number > entity.typeInfo.dosingPeriod) {
      return state.entity?.pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    if (number <= entity.lastTakenPillNumber) {
      return PillMarkType.done;
    }
    if (number < entity.todayPillNumber) {
      return PillMarkType.normal;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation(int number) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    return number > entity.lastTakenPillNumber &&
        number <= entity.todayPillNumber;
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

modifyBeginingDateFunction(
  WriteBatch batch,
  PillSheetService service,
  PillSheetModifiedHistoryService pillSheetModifiedHistoryService,
  PillSheet pillSheet,
  int pillNumber,
) {
  final updated = pillSheet.copyWith(
    beginingDate: calcBeginingDateFromNextTodayPillNumberFunction(
      pillSheet,
      pillNumber,
    ),
  );
  service.update(
    batch,
    updated,
  );

  final history = PillSheetModifiedHistoryServiceActionFactory
      .createChangedPillNumberAction(before: pillSheet, after: updated);
  pillSheetModifiedHistoryService.add(batch, history);
}

DateTime calcBeginingDateFromNextTodayPillNumberFunction(
  PillSheet pillSheet,
  int pillNumber,
) {
  if (pillNumber == pillSheet.todayPillNumber) return pillSheet.beginingDate;
  final diff = pillNumber - pillSheet.todayPillNumber;
  return pillSheet.beginingDate.subtract(Duration(days: diff));
}
