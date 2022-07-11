import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'premium_introduction_state.codegen.freezed.dart';

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
      debugPrint("[DEBUG] user does not hasDiscountEntitlement");
      return OfferingType.premium;
    }
    if (isOverDiscountDeadline) {
      debugPrint("[DEBUG] isOverDiscountDeadline is true");
      return OfferingType.premium;
    } else {
      debugPrint("[DEBUG] isOverDiscountDeadline is false");
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
    const premiumPackageOfferingType = OfferingType.premium;
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
