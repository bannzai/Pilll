import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/provider/service.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/state/pill_sheet.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetStoreProvider =
    StateNotifierProvider((ref) => PillSheetStateStore(ref.read));

class PillSheetStateStore extends StateNotifier<PillSheetState> {
  final Reader _read;
  PillSheetStateStore(this._read) : super(PillSheetState()) {
    Future(() async {
      state = PillSheetState(
          entity: await _read(fetchLastPillSheetProvider.future));
    });
  }

  Future<void> register(PillSheetModel model) {
    return _read(pillSheetServiceProvider)
        .register(model)
        .then((entity) => state = state..copyWith(entity: entity));
  }
}
