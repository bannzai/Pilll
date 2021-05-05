import 'dart:async';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

final recordPageStoreProvider = StateNotifierProvider((ref) => RecordPageStore(
    ref.watch(pillSheetServiceProvider), ref.watch(settingServiceProvider)));

class RecordPageStore extends StateNotifier<RecordPageState> {
  final PillSheetService _service;
  final SettingService _settingService;
  RecordPageStore(this._service, this._settingService)
      : super(RecordPageState(entity: null)) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final entity = await _service.fetchLast();
      final setting = await _settingService.fetch();
      state = RecordPageState(
          entity: entity, setting: setting, firstLoadIsEnded: true);
      if (entity != null) {
        analytics.logEvent(name: "count_of_remaining_pill", parameters: {
          "count": (entity.todayPillNumber - entity.lastTakenPillNumber)
        });
      }
      _subscribe();
    });
  }

  StreamSubscription<PillSheetModel>? canceller;
  StreamSubscription? _settingCanceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribeForLatestPillSheet().listen((event) {
      state = state.copyWith(entity: event);
    });
    _settingCanceller?.cancel();
    _settingCanceller = _settingService.subscribe().listen((setting) {
      state = state.copyWith(setting: setting);
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }

  Future<void> register(PillSheetModel model) {
    return _service
        .register(model)
        .then((entity) => state = state.copyWith(entity: entity));
  }

  Future<void> delete() {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    return _service.delete(entity).then((_) => _reset());
  }

  Future<dynamic> take(DateTime takenDate) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    final updated = entity.copyWith(lastTakenDate: takenDate);
    FlutterAppBadger.removeBadge();
    showIndicator();
    return _service.update(updated).then((value) {
      hideIndicator();
      state = state.copyWith(entity: updated);
    });
  }

  DateTime calcBeginingDateFromNextTodayPillNumber(int pillNumber) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }
    if (pillNumber == entity.todayPillNumber) return entity.beginingDate;
    final diff = pillNumber - entity.todayPillNumber;
    return entity.beginingDate.subtract(Duration(days: diff));
  }

  void modifyBeginingDate(int pillNumber) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("pill sheet not found");
    }

    _service
        .update(entity.copyWith(
            beginingDate: calcBeginingDateFromNextTodayPillNumber(pillNumber)))
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
}
