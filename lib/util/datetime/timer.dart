import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final timerStoreProvider = StateNotifierProvider.autoDispose(
  (ref) => TimerStateStore(),
);

class TimerStateStore extends StateNotifier<DateTime> {
  Timer? _timer;
  TimerStateStore() : super(now());

  void fire(DateTime start) {
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
