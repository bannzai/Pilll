import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/state/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationsStoreProvider = StateNotifierProvider.autoDispose((ref) =>
    MenstruationStore(ref.watch(menstruationServiceProvider),
        ref.watch(diaryServiceProvider)));

class MenstruationStore extends StateNotifier<MenstruationState> {
  final MenstruationService _service;
  final DiaryService _diaryService;
  MenstruationStore(this._service, this._diaryService)
      : super(MenstruationState()) {
    _reset();
  }

  void _reset() {
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    Future(() async {
      final entities = await _service.fetchAll();
      final diaries = await _diaryService.fetchListAround90Days(today());
      state = state.copyWith(
          entities: entities, diaries: diaries, isNotYetLoaded: false);
      _subscribe();
    });
  }

  StreamSubscription? _canceller;
  StreamSubscription? _diaryCanceller;
  void _subscribe() {
    _canceller?.cancel();
    _canceller = _service.subscribeAll().listen((entities) {
      state = state.copyWith(entities: entities);
    });
    _diaryCanceller?.cancel();
    _diaryCanceller = _diaryService.subscribe().listen((entities) {
      state = state.copyWith(diaries: entities);
    });
  }

  @override
  void dispose() {
    _canceller?.cancel();
    _diaryCanceller?.cancel();
    super.dispose();
  }

  void updateCurrentCalendarIndex(int index) {
    if (state.currentCalendarIndex == index) {
      return;
    }
    state = state.copyWith(currentCalendarIndex: index);
  }
}
