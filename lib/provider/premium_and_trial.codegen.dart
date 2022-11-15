import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/provider/user.dart';
import 'package:riverpod/riverpod.dart';

part 'premium_and_trial.codegen.freezed.dart';

@freezed
class PremiumAndTrial with _$PremiumAndTrial {
  factory PremiumAndTrial({
    required bool isTrial,
    required bool isPremium,
    required bool hasDiscountEntitlement,
    required DateTime? beginTrialDate,
    required DateTime? trialDeadlineDate,
    required DateTime? discountEntitlementDeadlineDate,
  }) = _PremiumAndTrial;
  PremiumAndTrial._();

  bool get trialIsAlreadyBegin => beginTrialDate != null;
  bool get premiumOrTrial => isPremium || isTrial;
  bool get isNotYetStartTrial => trialDeadlineDate == null;
}

final premiumAndTrialProvider = Provider<AsyncValue<PremiumAndTrial>>((ref) {
  final user = ref.watch(userProvider).asData;
  if (user == null) {
    return const AsyncValue.loading();
  }

  return AsyncValue.data(PremiumAndTrial(
    isTrial: user.value.isTrial,
    isPremium: user.value.isPremium,
    hasDiscountEntitlement: user.value.hasDiscountEntitlement,
    beginTrialDate: user.value.beginTrialDate,
    trialDeadlineDate: user.value.trialDeadlineDate,
    discountEntitlementDeadlineDate: user.value.discountEntitlementDeadlineDate,
  ));
});
