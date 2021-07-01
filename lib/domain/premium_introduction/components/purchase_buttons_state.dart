import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/object_wrappers.dart';

part 'purchase_buttons_state.freezed.dart';

String _offeringNameForLimited = "Limited";
String _offeringNameForPremium = "Premium";

@freezed
abstract class PurchaseButtonsState implements _$PurchaseButtonsState {
  PurchaseButtonsState._();
  factory PurchaseButtonsState({
    required Offerings offerings,
    required DateTime? trialDeadlineDate,
    required bool? isOverTrialDeadline,
  }) = _PurchaseButtonsState;

  String get _offeringName {
    final trialDeadlineDate = this.trialDeadlineDate;
    if (trialDeadlineDate == null) {
      return _offeringNameForPremium;
    }
    final isOverTrialDeadline = this.isOverTrialDeadline;
    if (isOverTrialDeadline == null) {
      return _offeringNameForPremium;
    }
    if (isOverTrialDeadline) {
      return _offeringNameForPremium;
    } else {
      return _offeringNameForLimited;
    }
  }

  List<Package> get _packages {
    final offering = offerings.all[_offeringName];
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
