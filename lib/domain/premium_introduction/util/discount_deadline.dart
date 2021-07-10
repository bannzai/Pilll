import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/datetime/timer.dart';

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
