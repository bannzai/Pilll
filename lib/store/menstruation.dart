import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/state/menstruation.dart';

final menstruationsStoreProvider = StateNotifierProvider.autoDispose(
    (ref) => MenstruationStore(ref.watch(menstruationServiceProvider)));

class MenstruationStore extends StateNotifier<MenstruationState> {
  final MenstruationService _service;
  MenstruationStore(this._service) : super(MenstruationState()) {
    _reset();
  }

  void _reset() {
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    Future(() async {
      final entities = await _service.fetchAll();
      state = state.copyWith(entities: entities, isNotYetLoaded: false);
      _subscribe();
    });
  }

  StreamSubscription? canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribeAll().listen((entities) {
      state = state.copyWith(entities: entities);
    });
  }

  void updateCurrentCalendarIndex(int index) {
    if (state.currentCalendarIndex == index) {
      return;
    }
    state = state.copyWith(currentCalendarIndex: index);
  }
}
