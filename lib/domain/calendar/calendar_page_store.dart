import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/calendar_page_async_action.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';

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
}
