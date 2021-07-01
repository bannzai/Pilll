import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recordPageStoreProvider = StateNotifierProvider((ref) => RecordPageStore(
      ref.watch(pillSheetServiceProvider),
      ref.watch(settingServiceProvider),
      ref.watch(authServiceProvider),
      ref.watch(userServiceProvider),
    ));

class RecordPageStore extends StateNotifier<RecordPageState> {
  final PillSheetService _service;
  final SettingService _settingService;
  final AuthService _authService;
  final UserService _userService;
  RecordPageStore(
    this._service,
    this._settingService,
    this._authService,
    this._userService,
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
      state = RecordPageState(
        entity: entity,
        setting: setting,
        firstLoadIsEnded: true,
        isLinkedLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
        totalCountOfActionForTakenPill: totalCountOfActionForTakenPill,
        exception: null,
        isPillSheetFinishedInThePast: isPillSheetFinishedInThePast,
        isAlreadyShowTiral:
            sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumTrialModal) ??
                false,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        shouldShowMigrateInfo: shouldShowMigrateInfo,
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
      state = state.copyWith(isPremium: event.isPremium);
    });
  }

  @override
  void dispose() {
    _canceller?.cancel();
    _settingCanceller?.cancel();
    super.dispose();
  }

  Future<void> register(PillSheet model) async {
    await _service
        .register(model)
        .then((entity) => state = state.copyWith(entity: entity));
  }

  Future<dynamic> take(DateTime takenDate) async {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    final updated = entity.copyWith(lastTakenDate: takenDate);
    FlutterAppBadger.removeBadge();
    await _service.update(updated);
    state = state.copyWith(entity: updated);
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

Future<PillSheet> modifyBeginingDateFunction(
  PillSheetService service,
  PillSheet pillSheet,
  int pillNumber,
) {
  return service.update(pillSheet.copyWith(
      beginingDate: calcBeginingDateFromNextTodayPillNumberFunction(
          pillSheet, pillNumber)));
}

DateTime calcBeginingDateFromNextTodayPillNumberFunction(
  PillSheet pillSheet,
  int pillNumber,
) {
  if (pillNumber == pillSheet.todayPillNumber) return pillSheet.beginingDate;
  final diff = pillNumber - pillSheet.todayPillNumber;
  return pillSheet.beginingDate.subtract(Duration(days: diff));
}
