import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/purchase.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final premiumIntroductionStoreProvider = StateNotifierProvider.autoDispose(
  (ref) => PremiumIntroductionStore(
    ref.watch(userServiceProvider),
    ref.watch(authServiceProvider),
    ref.watch(purchaseServiceProvider),
  ),
);
final premiumIntroductionStateProvider = Provider.autoDispose(
    (ref) => ref.watch(premiumIntroductionStoreProvider.state));

class PremiumIntroductionStore extends StateNotifier<PremiumIntroductionState> {
  final UserService _userService;
  final AuthService _authService;
  final PurchaseService _purchaseService;
  PremiumIntroductionStore(
      this._userService, this._authService, this._purchaseService)
      : super(PremiumIntroductionState()) {
    reset();
  }

  reset() {
    Future(() async {
      _subscribe();

      state = state.copyWith(
        hasLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
      );
      _userService.fetch().then((value) {
        state = state.copyWith(
          isPremium: value.isPremium,
          isTrial: value.isTrial,
          beginTrialDate: value.beginTrialDate,
          trialDeadlineDate: value.trialDeadlineDate,
          hasDiscountEntitlement: value.hasDiscountEntitlement,
        );
      });
      _purchaseService.fetchOfferings().then((value) {
        state = state.copyWith(offerings: value);
      });
    });
  }

  StreamSubscription? _userStreamCanceller;
  StreamSubscription? _authStreamCanceller;
  _subscribe() {
    _userStreamCanceller?.cancel();
    _userStreamCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        hasDiscountEntitlement: event.hasDiscountEntitlement,
      );
    });
    _authStreamCanceller?.cancel();
    _authStreamCanceller = _authService.subscribe().listen((_) {
      state = state.copyWith(
          hasLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
  }

  @override
  void dispose() {
    _userStreamCanceller?.cancel();
    _userStreamCanceller = null;
    _authStreamCanceller?.cancel();
    _authStreamCanceller = null;
    super.dispose();
  }

  String annualPriceString(Package package) {
    final monthlyPrice = package.product.price / 12;
    final monthlyPriceString =
        NumberFormat.simpleCurrency(decimalDigits: 0, name: "JPY")
            .format(monthlyPrice);
    return "${package.product.priceString} ($monthlyPriceString/月)";
  }

  String monthlyPriceString(Package package) {
    return "${package.product.priceString}";
  }
}
