import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/state/pill_sheet.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetStoreProvider =
    StateNotifierProvider((ref) => PillSheetStateStore(ref.read));

class PillSheetStateStore extends StateNotifier<PillSheetState> {
  final Reader _read;
  PillSheetServiceInterface get _service => _read(pillSheetServiceProvider);
  PillSheetStateStore(this._read) : super(PillSheetState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      state = PillSheetState(
          entity: await _read(fetchLastPillSheetProvider.future));
    });
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
    _service
        .update(state.entity..copyWith(lastTakenDate: takenDate))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void modifyBeginingDate(DateTime beginingDate) {
    _service
        .update(state.entity..copyWith(beginingDate: beginingDate))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void update(PillSheetModel entity) {
    state = state.copyWith(entity: entity);
  }
}
