import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:riverpod/riverpod.dart';

final menstruationCalendarPageIndexStateNotifierProvider =
    StateNotifierProvider<MenstruationCalendarPageIndexStateNotifier, int>(
  (ref) => MenstruationCalendarPageIndexStateNotifier(todayCalendarPageIndex),
);

class MenstruationCalendarPageIndexStateNotifier extends StateNotifier<int> {
  MenstruationCalendarPageIndexStateNotifier(
    int initialState,
  ) : super(initialState);

  void set(int index) {
    if (state != index) {
      state = index;
    }
  }
}
