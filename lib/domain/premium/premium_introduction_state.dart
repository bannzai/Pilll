import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'premium_introduction_state.freezed.dart';

@freezed
abstract class PremiumIntroductionState implements _$PremiumIntroductionState {
  PremiumIntroductionState._();
  factory PremiumIntroductionState({
    Offerings? offerings,
    Package? selectedPackage,
    @Default(false) bool isCompletedRestore,
    @Default(false) bool isPremium,
  }) = _PremiumIntroductionState;

  bool get isNotYetLoad => offerings == null;

  String? get currentOfferingID {
    return offerings?.current?.identifier;
  }

  List<Package> get packages {
    final offerings = this.offerings;
    if (offerings == null) {
      return [];
    }
    final currentOffering = offerings.current;
    if (currentOffering != null) {
      return currentOffering.availablePackages;
    }
    return [];
  }

  Package? get annualPackage {
    if (packages.isEmpty) {
      return null;
    }
    return packages
        .firstWhere((element) => element.packageType == PackageType.annual);
  }

  Package? get monthlyPackage {
    if (packages.isEmpty) {
      return null;
    }
    return packages
        .firstWhere((element) => element.packageType == PackageType.monthly);
  }

  bool get isSelectedAnnual => identical(annualPackage, selectedPackage);
  bool get isSelectedMonthly => identical(monthlyPackage, selectedPackage);
  String get doneButtonText {
    if (isSelectedAnnual) {
      return "年間プランでプレミアムに登録";
    }
    if (isSelectedMonthly) {
      return "月額プランでプレミアムに登録";
    }
    return "";
  }
}
