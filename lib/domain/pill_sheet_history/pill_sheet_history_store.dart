import 'dart:async';

import 'package:pilll/domain/pill_sheet_history/pill_sheet_history_state.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetHistoryStoreProvider = StateNotifierProvider.autoDispose(
  (ref) => PillSheetHistoryStateStore(ref.watch(pillSheetServiceProvider)),
);

class PillSheetHistoryStateStore extends StateNotifier<PillSheetHistoryState> {
  final PillSheetService _pillSheetService;
  PillSheetHistoryStateStore(
    this._pillSheetService,
  ) : super(PillSheetHistoryState()) {
    reset();
  }

  void reset() {
    Future(() async {
      final pillSheets = await _pillSheetService.fetchAll();
      state = state.copyWith(pillSheets: pillSheets);
    });
  }
}
