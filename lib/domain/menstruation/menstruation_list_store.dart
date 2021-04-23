import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/domain/menstruation/menstruation_list_state.dart';
import 'package:pilll/service/menstruation.dart';

final menstruationListStoreProvider = StateNotifierProvider((ref) =>
    MenstruationListStore(
        menstruationService: ref.watch(menstruationServiceProvider)));

class MenstruationListStore extends StateNotifier<MenstruationListState> {
  final MenstruationService menstruationService;
  MenstruationListStore({
    required this.menstruationService,
  }) : super(MenstruationListState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final menstruations = await menstruationService.fetchAll();
      state = state.copyWith(
        isNotYetLoaded: false,
        rows: MenstruationHistoryRowState.rows(menstruations),
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        menstruationService.subscribeAll().listen((entities) {
      state = state.copyWith(rows: MenstruationHistoryRowState.rows(entities));
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    super.dispose();
  }
}
