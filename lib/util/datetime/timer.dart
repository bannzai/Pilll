import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final timerStoreProvider = StateNotifierProvider(
  (ref) => TimerStateStore(),
);
final timerStateProvider = Provider.autoDispose(
  (ref) => ref.watch(timerStoreProvider.state),
);

class TimerStateStore extends StateNotifier<DateTime> {
  Timer? _timer;
  TimerStateStore() : super(now()) {
    _fire(state);
  }

  void _fire(DateTime start) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      state = now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
