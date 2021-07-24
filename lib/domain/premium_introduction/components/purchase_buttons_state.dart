import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/object_wrappers.dart';

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

@freezed
abstract class PurchaseButtonsState implements _$PurchaseButtonsState {
  PurchaseButtonsState._();
  factory PurchaseButtonsState({
    required Offerings offerings,
    required bool hasDiscountEntitlement,
    required bool isOverDiscountDeadline,
  }) = _PurchaseButtonsState;

  OfferingType get offeringType {
    if (!hasDiscountEntitlement) {
      print("[DEBUG] user does not hasDiscountEntitlement");
      return OfferingType.premium;
    }
    final isOverDiscountDeadline = this.isOverDiscountDeadline;
    if (isOverDiscountDeadline == null) {
      print("[DEBUG] isOverDiscountDeadline is null");
      return OfferingType.limited;
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
