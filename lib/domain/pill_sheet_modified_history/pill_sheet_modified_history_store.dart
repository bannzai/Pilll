import 'dart:async';
import 'dart:math';

import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_state.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryStoreProvider = StateNotifierProvider.autoDispose<
    PillSheetModifiedHistoryStateStore, PillSheetModifiedHistoryState>(
  (ref) => PillSheetModifiedHistoryStateStore(
    ref.watch(pillSheetModifiedHistoryDatastoreProvider),
  ),
);

class PillSheetModifiedHistoryStateStore
    extends StateNotifier<PillSheetModifiedHistoryState> {
  final PillSheetModifiedHistoryDatastore _pillSheetModifiedHistoryDatastore;
  PillSheetModifiedHistoryStateStore(
    this._pillSheetModifiedHistoryDatastore,
  ) : super(const PillSheetModifiedHistoryState()) {
    reset();
  }

  void reset() {
    state = state.copyWith(isLoading: true);
    Future(() async {
      final pillSheetModifiedHistories =
          await _pillSheetModifiedHistoryDatastore.fetchList(null, 20);
      state = state.copyWith(
        pillSheetModifiedHistories: pillSheetModifiedHistories,
        isFirstLoadEnded: true,
        isLoading: false,
      );
      _subscribe();
    });
  }

  StreamSubscription? _pillSheetModifiedHistoryCanceller;
  void _subscribe() {
    _pillSheetModifiedHistoryCanceller?.cancel();
    _pillSheetModifiedHistoryCanceller = _pillSheetModifiedHistoryDatastore
        .stream(max(state.pillSheetModifiedHistories.length, 20))
        .listen((event) {
      state = state.copyWith(pillSheetModifiedHistories: event);
    });
  }

  @override
  void dispose() {
    _pillSheetModifiedHistoryCanceller?.cancel();
    super.dispose();
  }

  Future<void> fetchNext() async {
    if (state.pillSheetModifiedHistories.isEmpty) {
      return Future.value();
    }
    state = state.copyWith(isLoading: true);
    final pillSheetModifiedHistories =
        await _pillSheetModifiedHistoryDatastore.fetchList(
            state.pillSheetModifiedHistories.last.estimatedEventCausingDate,
            20);
    state = state.copyWith(
        pillSheetModifiedHistories:
            state.pillSheetModifiedHistories + pillSheetModifiedHistories,
        isLoading: false);
    _subscribe();
  }

  Future<void> editTakenValue(
    DateTime actualTakenDate,
    PillSheetModifiedHistory history,
    PillSheetModifiedHistoryValue value,
    TakenPillValue takenPillValue,
  ) {
    return updateForEditTakenValue(
      service: _pillSheetModifiedHistoryDatastore,
      actualTakenDate: actualTakenDate,
      history: history,
      value: value,
      takenPillValue: takenPillValue,
    );
  }
}
