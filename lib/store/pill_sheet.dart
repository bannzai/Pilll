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
  final PillSheetServiceInterface _service;
  PillSheetStateStore(this._service) : super(PillSheetState()) {
    _reset();
  }

  var firstLoadIsEnded = false;
  void _reset() {
    Future(() async {
      state = PillSheetState(entity: await _service.fetchLast());
      analytics.logEvent(name: "count_of_remaining_pill", parameters: {
        "count": state.entity == null
            ? 0
            : (state.entity.todayPillNumber - state.entity.lastTakenPillNumber)
      });
      firstLoadIsEnded = true;
      _subscribe();
    });
  }

  StreamSubscription<PillSheetModel> canceller;
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
    return _service.delete(state.entity).then((_) => _reset());
  }

  Future<dynamic> take(DateTime takenDate) {
    showIndicator();
    final updated = state.entity.copyWith(lastTakenDate: takenDate);
    return _service.update(updated).then((value) {
      hideIndicator();
      state = state.copyWith(entity: updated);
    });
  }

  DateTime calcBeginingDateFromNextTodayPillNumber(int pillNumber) {
    if (pillNumber == state.entity.todayPillNumber)
      return state.entity.beginingDate;
    final diff = pillNumber - state.entity.todayPillNumber;
    return state.entity.beginingDate.subtract(Duration(days: diff));
  }

  void modifyBeginingDate(int pillNumber) {
    _service
        .update(state.entity.copyWith(
            beginingDate: calcBeginingDateFromNextTodayPillNumber(pillNumber)))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void update(PillSheetModel entity) {
    state = state.copyWith(entity: entity);
  }

  PillMarkType markFor(int number) {
    if (number > state.entity.typeInfo.dosingPeriod) {
      return state.entity.pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    if (number <= state.entity.lastTakenPillNumber) {
      return PillMarkType.done;
    }
    if (number < state.entity.todayPillNumber) {
      return PillMarkType.normal;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation(int number) {
    return number > state.entity.lastTakenPillNumber &&
        number <= state.entity.todayPillNumber;
  }
}
