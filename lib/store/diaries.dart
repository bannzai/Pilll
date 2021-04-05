import 'dart:async';

import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/entity/diary.dart';
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

  Future<void> register(Diary diary) {
    if (state.entities
        .where((element) => isSameDay(diary.date, element.date))
        .isNotEmpty) throw DiaryAleradyExists(diary);
    return _service.register(diary);
  }

  Future<void> update(Diary diary) {
    if (state.entities
        .where((element) => isSameDay(diary.date, element.date))
        .isEmpty) throw DiaryIsNotExists(diary);
    return _service.update(diary);
  }
}

class DiaryAleradyExists extends Error {
  final Diary _diary;

  DiaryAleradyExists(this._diary);
  @override
  toString() {
    return "${_diary.date}の日付の日記のデータが既に存在しています。";
  }
}

class DiaryIsNotExists extends Error {
  final Diary _diary;

  DiaryIsNotExists(this._diary);
  @override
  toString() {
    return "${_diary.date} の日付の日記のデータが存在しません。";
  }
}
