import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/datetime/timer.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

final isOverDiscountDeadlineProvider = Provider.family.autoDispose((ref, DateTime? discountEntitlementDeadlineDate) {
  if (discountEntitlementDeadlineDate == null) {
    // NOTE: discountEntitlementDeadlineDate が存在しない時はbackendの方でまだ期限を決めていないのでfalse状態で扱う
    return false;
  }
  final timer = ref.watch(timerStateProvider);
  return timer.isAfter(discountEntitlementDeadlineDate);
});

final hiddenCountdownDiscountDeadlineProvider = Provider.family.autoDispose((ref, DateTime? discountEntitlementDeadlineDate) {
  if (discountEntitlementDeadlineDate == null) {
    // NOTE: discountEntitlementDeadlineDate が存在しない時はbackendの方でまだ期限を決めていないのでfalse状態で扱う
    return false;
  }
  final timer = ref.watch(timerStateProvider);
  return !(timer.isBefore(discountEntitlementDeadlineDate) && discountEntitlementDeadlineDate.difference(timer).inMinutes <= 48 * 60);
});

final durationToDiscountPriceDeadline = Provider.family.autoDispose((ref, DateTime discountEntitlementDeadlineDate) {
  final timerDate = ref.watch(timerStateProvider);
  return discountEntitlementDeadlineDate.difference(timerDate);
});

String discountPriceDeadlineCountdownString(Duration diff) {
  final hour = diff.inHours;
  final minute = diff.inMinutes % 60;
  final second = diff.inSeconds % 60;
  return DateTimeFormatter.clock(hour.toInt(), minute.toInt(), second.toInt());
}
