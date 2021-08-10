import 'dart:async';
import 'dart:math';

import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_state.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryStoreProvider = StateNotifierProvider.autoDispose(
  (ref) => PillSheetModifiedHistoryStateStore(
    ref.watch(pillSheetModifiedHistoryServiceProvider),
  ),
);

class PillSheetModifiedHistoryStateStore
    extends StateNotifier<PillSheetModifiedHistoryState> {
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  PillSheetModifiedHistoryStateStore(
    this._pillSheetModifiedHistoryService,
  ) : super(PillSheetModifiedHistoryState()) {
    reset();
  }

  void reset() {
    state = state.copyWith(isLoading: true);
    Future(() async {
      final pillSheetModifiedHistories =
          await _pillSheetModifiedHistoryService.fetchList(null, 20);
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
    _pillSheetModifiedHistoryCanceller = _pillSheetModifiedHistoryService
        .subscribe(max(state.pillSheetModifiedHistories.length, 20))
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
    final pillSheetModifiedHistories = await _pillSheetModifiedHistoryService
        .fetchList(state.pillSheetModifiedHistories.last.createdAt, 20);
    state = state.copyWith(
        pillSheetModifiedHistories:
            state.pillSheetModifiedHistories + pillSheetModifiedHistories,
        isLoading: false);
    _subscribe();
  }
}
