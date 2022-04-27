import 'dart:async';

import 'package:pilll/domain/diary/diary_state.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/date_compare.dart';

class ConfirmDiaryStore extends StateNotifier<DiaryState> {
  final DiaryDatastore _diaryDatastore;
  ConfirmDiaryStore(this._diaryDatastore, DiaryState state) : super(state) {
    _subscribe();
  }

  StreamSubscription? canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _diaryDatastore.stream().listen((entities) {
      entities
          .where((element) => isSameDay(element.date, state.diary.date))
          .forEach((element) {
        state = state.copyWith(diary: element);
      });
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }

  Future<void> delete() {
    return _diaryDatastore.delete(state.diary);
  }
}
