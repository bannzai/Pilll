import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/state/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationsStoreProvider = StateNotifierProvider.autoDispose(
    (ref) => MenstruationStore(ref.watch(menstruationServiceProvider)));

class MenstruationStore extends StateNotifier<MenstruationState> {
  final MenstruationService _service;
  MenstruationStore(this._service)
      : super(MenstruationState(targetDate: firstDayOfWeekday(today()))) {
    _reset();
  }

  void _reset() {
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

  void updateDisplayedDate(DateTimeRange range) {
    if (state.targetDate.month == range.end.month) {
      return;
    }
    state = state.copyWith(targetDate: range.end);
  }
}
