import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/calendar_page_async_action.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';

final calendarPageStateNotifierProvider = StateNotifierProvider<
    CalendarPageStateNotifier, AsyncValue<CalendarPageState>>(
  (ref) => CalendarPageStateNotifier(
    asyncAction: ref.read(calendarPageAsyncActionProvider),
    initialState: ref.watch(calendarPageStateProvider),
  ),
);

class CalendarPageStateNotifier
    extends StateNotifier<AsyncValue<CalendarPageState>> {
  final CalendarPageAsyncAction asyncAction;

  CalendarPageStateNotifier({
    required this.asyncAction,
    required AsyncValue<CalendarPageState> initialState,
  }) : super(initialState);
}
