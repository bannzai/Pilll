import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discount_deadline.g.dart';

@Riverpod()
bool isOverDiscountDeadline(IsOverDiscountDeadlineRef ref, {required DateTime? discountEntitlementDeadlineDate}) {
  if (discountEntitlementDeadlineDate == null) {
    // NOTE: discountEntitlementDeadlineDate が存在しない時はbackendの方でまだ期限を決めていないのでfalse状態で扱う
    return false;
  }
  final timer = ref.watch(tickProvider);
  return timer.isAfter(discountEntitlementDeadlineDate);
}

@Riverpod(dependencies: [remoteConfigParameter])
bool hiddenCountdownDiscountDeadline(HiddenCountdownDiscountDeadlineRef ref, {required DateTime? discountEntitlementDeadlineDate}) {
  if (discountEntitlementDeadlineDate == null) {
    // NOTE: discountEntitlementDeadlineDate が存在しない時はbackendの方でまだ期限を決めていないのでfalse状態で扱う
    return false;
  }
  final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
  final timer = ref.watch(tickProvider);
  return !(timer.isBefore(discountEntitlementDeadlineDate) &&
      discountEntitlementDeadlineDate.difference(timer).inMinutes <= remoteConfigParameter.discountCountdownBoundaryHour * 60);
}

@Riverpod()
Duration durationToDiscountPriceDeadline(DurationToDiscountPriceDeadlineRef ref, {required DateTime discountEntitlementDeadlineDate}) {
  final timerDate = ref.watch(tickProvider);
  return discountEntitlementDeadlineDate.difference(timerDate);
}

String discountPriceDeadlineCountdownString(Duration diff) {
  final hour = diff.inHours;
  final minute = diff.inMinutes % 60;
  final second = diff.inSeconds % 60;
  return DateTimeFormatter.clock(hour.toInt(), minute.toInt(), second.toInt());
}
