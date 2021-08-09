import 'dart:async';

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
      final elements = _mapToElements(pillSheetModifiedHistories);
      state = state.copyWith(
          elements: elements, isFirstLoadEnded: true, isLoading: false);
      _subscribe();
    });
  }

  StreamSubscription? _pillSheetModifiedHistoryCanceller;
  void _subscribe() {
    _pillSheetModifiedHistoryCanceller?.cancel();
    _pillSheetModifiedHistoryCanceller = _pillSheetModifiedHistoryService
        .subscribe(state.elements.length)
        .listen((event) {
      final elements = _mapToElements(event);
      state = state.copyWith(elements: elements);
    });
  }

  List<PillSheetModifiedHistoryElementState> _mapToElements(
      List<PillSheetModifiedHistory> histories) {
    return histories
        .where((history) => history.enumActionType != null)
        .map(
          (history) => PillSheetModifiedHistoryElementState(
            actionType: history.enumActionType!,
            createdAt: history.createdAt,
            value: history.value,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _pillSheetModifiedHistoryCanceller?.cancel();
    super.dispose();
  }
}
