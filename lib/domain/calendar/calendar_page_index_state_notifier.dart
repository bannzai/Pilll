import 'package:pilll/database/diary.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';

import 'package:riverpod/riverpod.dart';

final calendarPageIndexStateNotifierProvider =
    StateNotifierProvider<CalendarPageIndexStateNotifier, int>(
  (ref) => CalendarPageIndexStateNotifier(
      todayCalendarPageIndex, ref.watch(diaryDatastoreProvider)),
);

class CalendarPageIndexStateNotifier extends StateNotifier<int> {
  final DiaryDatastore _diaryDatastore;
  CalendarPageIndexStateNotifier(
    int initialState,
    this._diaryDatastore,
  ) : super(initialState) {
    _prefetch(initialState);
  }

  void set(int index) {
    if (state == index) {
      return;
    }

    _prefetch(index);

    state = index;
  }

  void _prefetch(int index) {
    _diaryDatastore.fetchListForMonth(calendarDataSource[index]);

    if (calendarDataSource.length > index) {
      _diaryDatastore.fetchListForMonth(calendarDataSource[index + 1]);
    }
    if (calendarDataSource.length < index) {
      _diaryDatastore.fetchListForMonth(calendarDataSource[index - 1]);
    }
  }
}
