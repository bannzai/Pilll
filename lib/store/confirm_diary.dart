import 'package:pilll/service/diary.dart';
import 'package:pilll/state/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmDiary extends StateNotifier<DiaryState> {
  final DiaryService _service;
  ConfirmDiary(this._service, DiaryState state) : super(state);

  Future<void> delete() {
    return _service.delete(state.entity);
  }
}
