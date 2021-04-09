import 'dart:async';

import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/state/pill_sheet.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetStoreProvider = StateNotifierProvider(
    (ref) => PillSheetStateStore(ref.watch(pillSheetServiceProvider)));

class PillSheetStateStore extends StateNotifier<PillSheetState> {
  final PillSheetService _service;
  PillSheetStateStore(this._service) : super(PillSheetState(entity: null)) {
    _reset();
  }

  var firstLoadIsEnded = false;
  void _reset() {
    Future(() async {
      final entity = await _service.fetchLast();
      state = PillSheetState(entity: entity);
      analytics.logEvent(name: "count_of_remaining_pill", parameters: {
        "count": (entity.todayPillNumber - entity.lastTakenPillNumber)
      });
      firstLoadIsEnded = true;
      _subscribe();
    });
  }

  StreamSubscription<PillSheetModel>? canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribeForLatestPillSheet().listen((event) {
      state = PillSheetState(entity: event);
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

  void update(PillSheetModel entity) {
    state = state.copyWith(entity: entity);
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
