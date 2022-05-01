import 'package:mockito/mockito.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

class FakePremiumAndTrial extends Mock implements PremiumAndTrial {
  FakePremiumAndTrial({
// ignore: unused_element
    this.fakeIsPremium = false,
// ignore: unused_element
    this.fakeIsTrial = false,
// ignore: unused_element
    this.fakeTrialDeadlineDate,
// ignore: unused_element
    this.fakeDiscountEntitlementDeadlineDate,
// ignore: unused_element
    this.fakeIsExpiredDiscountEntitlements = false,
  });
  final DateTime? fakeTrialDeadlineDate;
  final DateTime? fakeDiscountEntitlementDeadlineDate;
  final bool fakeIsPremium;
  final bool fakeIsTrial;
  final bool fakeIsExpiredDiscountEntitlements;

  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get isTrial => fakeIsTrial;
  @override
  bool get hasDiscountEntitlement => fakeIsExpiredDiscountEntitlements;
  @override
  DateTime? get trialDeadlineDate => fakeTrialDeadlineDate;
  @override
  DateTime? get discountEntitlementDeadlineDate =>
      fakeDiscountEntitlementDeadlineDate;
}
