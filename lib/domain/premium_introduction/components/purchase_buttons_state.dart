import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:riverpod/riverpod.dart';

part 'purchase_buttons_state.freezed.dart';

enum OfferingType { limited, premium }

extension OfferingTypeFunction on OfferingType {
  String get name {
    switch (this) {
      case OfferingType.limited:
        return "Limited";
      case OfferingType.premium:
        return "Premium";
    }
  }
}

final purchaseButtonsStateProvider =
    Provider.family.autoDispose((ref, Offerings offerings) {
  final premiumIntroductionState = ref.watch(premiumIntroductionStateProvider);
  final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(
      premiumIntroductionState.discountEntitlementDeadlineDate));
  return PurchaseButtonsState(
      offerings: offerings,
      hasDiscountEntitlement: premiumIntroductionState.hasDiscountEntitlement,
      isOverDiscountDeadline: isOverDiscountDeadline);
});

@freezed
class PurchaseButtonsState with _$PurchaseButtonsState {
  PurchaseButtonsState._();
  const factory PurchaseButtonsState({
    required Offerings offerings,
    required bool hasDiscountEntitlement,
    required bool isOverDiscountDeadline,
  }) = _PurchaseButtonsState;

  OfferingType get offeringType {
    if (!hasDiscountEntitlement) {
      print("[DEBUG] user does not hasDiscountEntitlement");
      return OfferingType.premium;
    }
    if (isOverDiscountDeadline) {
      print("[DEBUG] isOverDiscountDeadline is true");
      return OfferingType.premium;
    } else {
      print("[DEBUG] isOverDiscountDeadline is false");
      return OfferingType.limited;
    }
  }

  List<Package> get _packages {
    final offering = offerings.all[offeringType.name];
    if (offering != null) {
      return offering.availablePackages;
    }
    return [];
  }

  Package? get annualPackage {
    if (_packages.isEmpty) {
      return null;
    }
    return _packages
        .firstWhere((element) => element.packageType == PackageType.annual);
  }

  Package? get monthlyPackage {
    if (_packages.isEmpty) {
      return null;
    }
    return _packages
        .firstWhere((element) => element.packageType == PackageType.monthly);
  }
}
