import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';

import 'package:riverpod/riverpod.dart';

final calendarPageIndexStateNotifierProvider =
    StateNotifierProvider<CalendarPageIndexStateNotifier, int>(
  (ref) => CalendarPageIndexStateNotifier(todayCalendarPageIndex),
);

class CalendarPageIndexStateNotifier extends StateNotifier<int> {
  CalendarPageIndexStateNotifier(
    int initialState,
  ) : super(initialState);

  void set(int index) {
    if (state != index) {
      state = index;
    }
  }
}
