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

  void delete(String userID, PillSheetModel pillSheet) {
    _service.delete(pillSheet).then((_) => _reset());
  }
}
