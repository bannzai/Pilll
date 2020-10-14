import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/provider/service.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/state/pill_sheet.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetStoreProvider =
    StateNotifierProvider((ref) => PillSheetStateStore(ref.read));

class PillSheetStateStore extends StateNotifier<PillSheetState> {
  final Reader _read;
  PillSheetServiceInterface get _service => _read(pillSheetServiceProvider);
  PillSheetStateStore(this._read) : super(PillSheetState()) => _reset();

  _reset() {
    Future(() async {
      state = PillSheetState(
          entity: await _read(fetchLastPillSheetProvider.future));
    });
  }

  void register(PillSheetModel model) {
    _service
        .register(model)
        .then((entity) => state = state..copyWith(entity: entity));
  }

  void delete() {
    _service.delete(state.entity).then((_) => _reset());
  }

  void take(DateTime takenDate) {
    _service
        .take(state.entity, takenDate)
        .then((entity) => state = state..copyWith(entity: entity));
  }
}
