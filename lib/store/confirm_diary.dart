import 'dart:async';

import 'package:pilll/service/diary.dart';
import 'package:pilll/state/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/date_compare.dart';

class ConfirmDiary extends StateNotifier<DiaryState> {
  final DiaryService _service;
  ConfirmDiary(this._service, DiaryState state) : super(state) {
    _subscribe();
  }

  StreamSubscription? canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribe().listen((entities) {
      entities
          .where((element) => isSameDay(element.date, state.entity.date))
          .forEach((element) {
        state = state.copyWith(entity: element);
      });
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }

  Future<void> delete() {
    return _service.delete(state.entity);
  }
}
