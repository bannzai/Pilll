import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'premium_introduction_state.freezed.dart';

@freezed
abstract class PremiumIntroductionState implements _$PremiumIntroductionState {
  PremiumIntroductionState._();
  factory PremiumIntroductionState({
    Offerings? offerings,
  }) = _PremiumIntroductionState;

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
}
