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
      : super(MenstruationState(
            targetDate: today().subtract(Duration(days: today().weekday))));

  void updateDisplayedDate(DateTimeRange range) {
    state = state.copyWith(targetDate: range.end);
  }
}
