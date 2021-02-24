import 'dart:async';

import 'package:Pilll/analytics.dart';
import 'package:Pilll/components/molecules/indicator.dart';
import 'package:Pilll/entity/pill_mark_type.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
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
      state =
          PillSheetState.one(latestPillSheet: (await _service.fetchLatest()));
      analytics.logEvent(name: "count_of_remaining_pill", parameters: {
        "count": state.latestPillSheet == null
            ? 0
            : (state.latestPillSheet.todayPillNumber -
                state.latestPillSheet.lastTakenPillNumber)
      });
      firstLoadIsEnded = true;
      _subscribe();
    });
  }

  StreamSubscription<PillSheetModel> canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribeForLatestPillSheet().listen((event) {
      state = PillSheetState.one(latestPillSheet: event);
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
        .then((entity) => state = state.copyWith(latestPillSheet: entity));
  }

  Future<void> delete() {
    return _service.delete(state.latestPillSheet).then((_) => _reset());
  }

  Future<dynamic> take(DateTime takenDate) {
    showIndicator();
    final updated = state.latestPillSheet.copyWith(lastTakenDate: takenDate);
    return _service.update(updated).then((value) {
      hideIndicator();
      state = state.copyWith(latestPillSheet: updated);
    });
  }

  DateTime calcBeginingDateFromNextTodayPillNumber(int pillNumber) {
    if (pillNumber == state.latestPillSheet.todayPillNumber)
      return state.latestPillSheet.beginingDate;
    final diff = pillNumber - state.latestPillSheet.todayPillNumber;
    return state.latestPillSheet.beginingDate.subtract(Duration(days: diff));
  }

  void modifyBeginingDate(int pillNumber) {
    _service
        .update(state.latestPillSheet.copyWith(
            beginingDate: calcBeginingDateFromNextTodayPillNumber(pillNumber)))
        .then((entity) => state = state.copyWith(latestPillSheet: entity));
  }

  void update(PillSheetModel entity) {
    state = state.copyWith(latestPillSheet: entity);
  }

  PillMarkType markFor(int number) {
    if (number > state.latestPillSheet.typeInfo.dosingPeriod) {
      return state.latestPillSheet.pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    if (number <= state.latestPillSheet.lastTakenPillNumber) {
      return PillMarkType.done;
    }
    if (number < state.latestPillSheet.todayPillNumber) {
      return PillMarkType.normal;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation(int number) {
    return number > state.latestPillSheet.lastTakenPillNumber &&
        number <= state.latestPillSheet.todayPillNumber;
  }
}
