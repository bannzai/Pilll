import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/timer.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

final discountPriceDeadlineProvider =
    Provider.family.autoDispose((ref, DateTime trialDeadlineDate) {
  return trialDeadlineDate.add(Duration(hours: 48));
});

final isOverDiscountDeadlineProvider =
    Provider.family.autoDispose((ref, DateTime trialDeadlineDate) {
  final timer = ref.watch(timerStateProvider);
  final discountDeadline =
      ref.watch(discountPriceDeadlineProvider(trialDeadlineDate));
  return timer.isAfter(discountDeadline);
});

final durationToDiscountPriceDeadline =
    Provider.family.autoDispose((ref, DateTime trialDeadlineDate) {
  final timerDate = ref.watch(timerStateProvider);
  final discountDeadline =
      ref.watch(discountPriceDeadlineProvider(trialDeadlineDate));
  return discountDeadline.difference(timerDate);
});

String discountPriceDeadlineCountdownString(Duration diff) {
  final hour = diff.inHours;
  final minute = diff.inMinutes % 60;
  final second = diff.inSeconds % 60;
  return DateTimeFormatter.clock(hour.toInt(), minute.toInt(), second.toInt());
}
