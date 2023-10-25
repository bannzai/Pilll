import 'dart:async';

import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tick.g.dart';

@Riverpod()
class Tick extends _$Tick {
  Timer? _timer;

  @override
  DateTime build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = now();
    });
    return now();
  }
}
