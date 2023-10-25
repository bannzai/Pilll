import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';
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
    final n = now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = n;
    });
    return n;
  }
}
