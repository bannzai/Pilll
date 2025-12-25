import 'package:pilll/provider/tick.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discount_deadline.g.dart';

@Riverpod()
bool isOverDiscountDeadline(Ref ref, {required DateTime? discountEntitlementDeadlineDate}) {
  if (discountEntitlementDeadlineDate == null) {
    // NOTE: discountEntitlementDeadlineDate が存在しない時はbackendの方でまだ期限を決めていないのでfalse状態で扱う
    return false;
  }
  final timer = ref.watch(tickProvider);
  return timer.isAfter(discountEntitlementDeadlineDate);
}

// NOTE: テスト用に用意しているprovider
@Riverpod(dependencies: [])
bool hiddenCountdownDiscountDeadline(Ref ref, {required DateTime? discountEntitlementDeadlineDate}) {
  final user = ref.watch(userProvider);
  return user.asData?.value.hasDiscountEntitlement != true;
}

@Riverpod()
Duration durationToDiscountPriceDeadline(Ref ref, {required DateTime discountEntitlementDeadlineDate}) {
  final timerDate = ref.watch(tickProvider);
  return discountEntitlementDeadlineDate.difference(timerDate);
}

String discountPriceDeadlineCountdownString(Duration diff) {
  final hour = diff.inHours;
  final minute = diff.inMinutes % 60;
  final second = diff.inSeconds % 60;
  return DateTimeFormatter.clock(hour.toInt(), minute.toInt(), second.toInt());
}
