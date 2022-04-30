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
  ) : super(initialState);

  void set(int index) {
    if (state == index) {
      return;
    }

    // Prefetch diary data
    _diaryDatastore.fetchListForMonth(calendarDataSource[index]);

    state = index;
  }
}
