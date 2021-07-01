import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/object_wrappers.dart';

part 'purchase_buttons_state.freezed.dart';

@freezed
abstract class PurchaseButtonsState implements _$PurchaseButtonsState {
  PurchaseButtonsState._();
  factory PurchaseButtonsState({
    required Offerings offerings,
    required isOverTrialDeadline,
  }) = _PurchaseButtonsState;

  List<Package> get _packages {
    final currentOffering = offerings.current;
    if (currentOffering != null) {
      return currentOffering.availablePackages;
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
