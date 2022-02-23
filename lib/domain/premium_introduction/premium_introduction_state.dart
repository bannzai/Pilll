import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_state.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'premium_introduction_state.freezed.dart';

@freezed
class PremiumIntroductionState with _$PremiumIntroductionState {
  const PremiumIntroductionState._();
  const factory PremiumIntroductionState({
    Offerings? offerings,
    @Default(false) bool isOverDiscountDeadline,
    @Default(false) bool isCompletedRestore,
    @Default(false) bool isLoading,
    @Default(false) bool isPremium,
    @Default(false) bool hasLoginProvider,
    @Default(false) bool isTrial,
    @Default(false) bool hasDiscountEntitlement,
    DateTime? beginTrialDate,
    DateTime? discountEntitlementDeadlineDate,
  }) = _PremiumIntroductionState;

  bool get isNotYetLoad => offerings == null;

  OfferingType get currentOfferingType {
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

  List<Package> get _currentOfferingPackages {
    final offering = offerings?.all[currentOfferingType.name];
    if (offering != null) {
      return offering.availablePackages;
    }
    return [];
  }

  Package? get annualPackage {
    if (_currentOfferingPackages.isEmpty) {
      return null;
    }
    return _currentOfferingPackages
        .firstWhere((element) => element.packageType == PackageType.annual);
  }

  Package? get monthlyPackage {
    if (_currentOfferingPackages.isEmpty) {
      return null;
    }
    return _currentOfferingPackages
        .firstWhere((element) => element.packageType == PackageType.monthly);
  }

  Package? get monthlyPremiumPackage {
    final premiumPackageOfferingType = OfferingType.premium;
    final offering = offerings?.all[premiumPackageOfferingType.name];
    if (offering == null) {
      return null;
    }
    return offering.availablePackages
        .firstWhere((element) => element.packageType == PackageType.monthly);
  }
}

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
