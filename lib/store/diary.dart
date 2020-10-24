import 'dart:async';

import 'package:Pilll/main/utility/utility.dart';
import 'package:Pilll/model/diary.dart';
import 'package:Pilll/service/diary.dart';
import 'package:Pilll/state/diary.dart';
import 'package:riverpod/all.dart';

final diariesStoreProvider = StateNotifierProvider(
    (ref) => DiariesStateStore(ref.watch(diariesServiceProvider)));

class DiariesStateStore extends StateNotifier<DiariesState> {
  final DiariesServiceInterface _service;
  DiariesStateStore(this._service) : super(DiariesState()) {
    _subscribe();
  }

  StreamSubscription canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribe().listen((entities) {
      assert(entities != null, "Diary could not null on subscribe");
      if (entities == null) return;
      state = state.copyWith(entities: state.merged(entities));
    });
  }

  void fetchListForMonth(DateTime dateTimeOfMonth) {
    _service.fetchListForMonth(dateTimeOfMonth).then(
        (entities) => state = state.copyWith(entities: state.merged(entities)));
  }

  void register(Diary diary) {
    if (state.entities
        .where((element) => isSameDay(diary.date, element.date))
        .isNotEmpty) throw DiaryAleradyExists(diary);
    _service.register(diary);
  }
}

class DiaryAleradyExists implements Exception {
  final Diary _diary;

  DiaryAleradyExists(this._diary);
  toString() {
    return "diary already exists for date ${_diary.date}";
  }
}
