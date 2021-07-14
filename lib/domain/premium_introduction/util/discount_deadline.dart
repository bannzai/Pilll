import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/timer.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

final isOverDiscountDeadlineProvider =
    Provider.family.autoDispose((ref, DateTime discountDeadlineDate) {
  final timer = ref.watch(timerStateProvider);
  return timer.isAfter(discountDeadlineDate);
});

final durationToDiscountPriceDeadline =
    Provider.family.autoDispose((ref, DateTime discountDeadlineDate) {
  final timerDate = ref.watch(timerStateProvider);
  return discountDeadlineDate.difference(timerDate);
});

String discountPriceDeadlineCountdownString(Duration diff) {
  final hour = diff.inHours;
  final minute = diff.inMinutes % 60;
  final second = diff.inSeconds % 60;
  return DateTimeFormatter.clock(hour.toInt(), minute.toInt(), second.toInt());
}
