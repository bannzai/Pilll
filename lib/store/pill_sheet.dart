import 'dart:async';

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

  void modifyBeginingDate(DateTime beginingDate) {
    _service
        .update(state.entity.copyWith(beginingDate: beginingDate))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void update(PillSheetModel entity) {
    state = state.copyWith(entity: entity);
  }
}
