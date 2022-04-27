import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.codegen.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/purchase.dart';
import 'package:pilll/database/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:pilll/domain/premium_introduction/util/map_to_error.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error_log.dart';
import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';
import 'package:riverpod/riverpod.dart';

final premiumIntroductionStoreProvider = StateNotifierProvider.autoDispose<
    PremiumIntroductionStore, PremiumIntroductionState>(
  (ref) => PremiumIntroductionStore(
    ref.watch(userDatastoreProvider),
    ref.watch(authServiceProvider),
    ref.watch(purchaseServiceProvider),
  ),
);
final premiumIntroductionStateProvider =
    Provider.autoDispose((ref) => ref.watch(premiumIntroductionStoreProvider));

class PremiumIntroductionStore extends StateNotifier<PremiumIntroductionState> {
  final UserDatastore _userDatastore;
  final AuthService _authService;
  final PurchaseService _purchaseService;
  PremiumIntroductionStore(
      this._userDatastore, this._authService, this._purchaseService)
      : super(const PremiumIntroductionState()) {
    reset();
  }

  reset() {
    Future(() async {
      _subscribe();

      state = state.copyWith(
        hasLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
      );
      _userDatastore.fetch().then((value) {
        state = state.copyWith(
          isPremium: value.isPremium,
          isTrial: value.isTrial,
          beginTrialDate: value.beginTrialDate,
          discountEntitlementDeadlineDate:
              value.discountEntitlementDeadlineDate,
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
    _userStreamCanceller = _userDatastore.stream().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        hasDiscountEntitlement: event.hasDiscountEntitlement,
      );
    });
    _authStreamCanceller?.cancel();
    _authStreamCanceller = _authService.stream().listen((_) {
      state = state.copyWith(
          hasLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
  }

  @override
  void dispose() {
    stopStream();
    super.dispose();
  }

  startStream() {
    _subscribe();
  }

  stopStream() {
    _userStreamCanceller?.cancel();
    _userStreamCanceller = null;
    _authStreamCanceller?.cancel();
    _authStreamCanceller = null;
  }

  /// Return true indicates end of regularllly pattern.
  /// Return false indicates not regulally pattern.
  /// Return value is used to display the completion page
  Future<bool> purchase(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      final premiumEntitlement =
          purchaserInfo.entitlements.all[premiumEntitlements];
      if (premiumEntitlement == null) {
        throw AssertionError("unexpected premium entitlements is not exists");
      }
      if (!premiumEntitlement.isActive) {
        throw UserDisplayedError("課金の有効化が完了しておりません。しばらく時間をおいてからご確認ください");
      }
      await callUpdatePurchaseInfo(purchaserInfo);
      return Future.value(true);
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(name: "catched_purchase_exception", parameters: {
        "code": exception.code,
        "details": exception.details.toString(),
        "message": exception.message
      });
      final newException = mapToDisplayedException(exception);
      if (newException == null) {
        return Future.value(false);
      }
      errorLogger.recordError(exception, stack);
      throw newException;
    } catch (exception, stack) {
      analytics.logEvent(name: "catched_purchase_anonymous", parameters: {
        "exception_type": exception.runtimeType.toString(),
      });
      errorLogger.recordError(exception, stack);
      rethrow;
    }
  }
}
