import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/user.dart';

@immutable
class PremiumStateContainer {
  final bool isPremium;
  // For trial
  final bool isTrial;
  final DateTime? beginTrialDate;
  final DateTime? trialDeadlineDate;
  // For discount
  final bool hasDiscountEntitlement;
  final DateTime? discountEntitlementDeadlineDate;

  PremiumStateContainer({
    required this.isPremium,
    required this.isTrial,
    required this.beginTrialDate,
    required this.trialDeadlineDate,
    required this.hasDiscountEntitlement,
    required this.discountEntitlementDeadlineDate,
  });
}

final premiumStateStreamProvider = StreamProvider((ref) => ref
    .watch(userServiceProvider)
    .subscribe()
    .map((user) => PremiumStateContainer(
          isTrial: user.isTrial,
          isPremium: user.isPremium,
          beginTrialDate: user.beginTrialDate,
          trialDeadlineDate: user.trialDeadlineDate,
          hasDiscountEntitlement: user.hasDiscountEntitlement,
          discountEntitlementDeadlineDate: user.discountEntitlementDeadlineDate,
        )));
