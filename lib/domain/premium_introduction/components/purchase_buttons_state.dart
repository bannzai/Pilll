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
    required DateTime? trialDeadlineDate,
    required bool? isOverTrialDeadline,
  }) = _PurchaseButtonsState;

  OfferingType get _offeringType {
    final trialDeadlineDate = this.trialDeadlineDate;
    if (trialDeadlineDate == null) {
      return OfferingType.premium;
    }
    final isOverTrialDeadline = this.isOverTrialDeadline;
    if (isOverTrialDeadline == null) {
      return OfferingType.premium;
    }
    if (isOverTrialDeadline) {
      return OfferingType.premium;
    } else {
      return OfferingType.limited;
    }
  }

  List<Package> get _packages {
    final offering = offerings.all[_offeringType.name];
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
