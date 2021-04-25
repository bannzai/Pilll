import 'dart:async';

import 'package:pilll/service/diary.dart';
import 'package:pilll/state/diaries.dart';
import 'package:riverpod/riverpod.dart';

final monthlyDiariesStoreProvider =
    StateNotifierProvider.family<DiariesStateStore, DateTime>((ref, date) =>
        DiariesStateStore(ref.watch(diaryServiceProvider), date));

class DiariesStateStore extends StateNotifier<DiariesState> {
  final DiaryService _service;
  final DateTime dateForMonth;
  DiariesStateStore(this._service, this.dateForMonth)
      : super(DiariesState(entities: [])) {
    _reset();
  }

  void _reset() {
    Future(() async {
      state = state.copyWith(
          entities: await _service.fetchListForMonth(dateForMonth));
      _subscribe();
    });
  }

  StreamSubscription? canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribe().listen((entities) {
      state = state.copyWith(entities: entities);
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }
}
