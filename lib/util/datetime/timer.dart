import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

class Timer {
  Stream<DateTime> subscribe(DateTime start) {
    return Stream.periodic(
      Duration(seconds: 1),
      (x) => start.add(Duration(seconds: x)),
    );
  }
}

final timerStoreProvider = StateNotifierProvider.autoDispose(
  (ref) => TimerStateStore(),
);

class TimerStateStore extends StateNotifier<DateTime> {
  final _timer = Timer();
  StreamSubscription<DateTime>? _timerSubscription;
  TimerStateStore() : super(now());

  void fire(DateTime start) {
    _timerSubscription?.cancel();
    _timerSubscription = _timer.subscribe(start).listen((clock) {
      state = clock;
    });
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    super.dispose();
  }
}
