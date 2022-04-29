import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/calendar_page_async_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/util/datetime/date_compare.dart';

final calendarPageStateStoreProvider = StateNotifierProvider<
    CalendarPageStateStore, AsyncValue<CalendarPageState>>(
  (ref) => CalendarPageStateStore(
    asyncAction: ref.read(calendarPageAsyncActionProvider),
    initialState: ref.watch(calendarPageStateProvider),
  ),
);

class CalendarPageStateStore
    extends StateNotifier<AsyncValue<CalendarPageState>> {
  final CalendarPageAsyncAction asyncAction;

  CalendarPageStateStore({
    required this.asyncAction,
    required AsyncValue<CalendarPageState> initialState,
  }) : super(initialState);

  // TODO: Remove
  void updateCurrentCalendarIndex(int index) {
    final value = state.asData?.value;
    if (value == null) {
      return;
    }
    if (value.currentCalendarIndex == index) {
      return;
    }
    state = AsyncValue.data(value.copyWith(currentCalendarIndex: index));

    // TODO: Remove or move to asyncAction
    //   final date = state.calendarDataSource[state.currentCalendarIndex];
    //   _diaryDatastore.fetchListForMonth(date).then((diaries) {
    //     final ignoredSameMonth = state.diariesForMonth
    //         .where((element) => !isSameMonth(element.date, date))
    //         .toList();
    //     final updated = ignoredSameMonth..addAll(diaries);
    //     state = state.copyWith(diariesForMonth: updated);
    //   });
  }
}
