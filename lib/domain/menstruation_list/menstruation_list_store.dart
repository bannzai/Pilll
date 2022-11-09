import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_state.codegen.dart';
import 'package:pilll/database/menstruation.dart';

final menstruationListStateNotifierProvider = StateNotifierProvider<MenstruationListStore, MenstruationListState>(
  (ref) => MenstruationListStore(
    menstruationDatastore: ref.watch(menstruationDatastoreProvider),
  ),
);

class MenstruationListStore extends StateNotifier<MenstruationListState> {
  final MenstruationDatastore menstruationDatastore;
  MenstruationListStore({
    required this.menstruationDatastore,
  }) : super(const MenstruationListState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final menstruations = await menstruationDatastore.fetchAll();
      state = state.copyWith(
        isNotYetLoaded: false,
        allMenstruations: menstruations,
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller = menstruationDatastore.streamAll().listen((entities) {
      state = state.copyWith(allMenstruations: entities);
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    super.dispose();
  }
}
