import 'dart:async';

import 'package:Pilll/entity/pill_mark_type.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/state/pill_sheet.dart';
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

  void delete() {
    _service.delete(state.entity).then((_) => _reset());
  }

  void take(DateTime takenDate) {
    _service.update(state.entity.copyWith(lastTakenDate: takenDate));
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
    if (number < state.entity.todayPillNumber) {
      return PillMarkType.done;
    }
    if (number == state.entity.todayPillNumber && state.entity.allTaken) {
      return PillMarkType.done;
    }
    if (number > state.entity.typeInfo.dosingPeriod) {
      return PillMarkType.notTaken;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation(int number) {
    if (number > state.entity.typeInfo.dosingPeriod) {
      return false;
    }
    if (state.entity.allTaken) {
      return false;
    }
    return number == state.entity.todayPillNumber;
  }
}
