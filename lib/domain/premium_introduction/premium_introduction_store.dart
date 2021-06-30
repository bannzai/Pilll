import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.dart';
import 'package:pilll/domain/premium_introduction/util/map_to_error.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/purchases.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final premiumIntroductionStoreProvider = StateNotifierProvider.autoDispose(
    (ref) => PremiumIntroductionStore(
        ref.watch(userServiceProvider), ref.watch(authServiceProvider)));

class PremiumIntroductionStore extends StateNotifier<PremiumIntroductionState> {
  final UserService _userService;
  final AuthService _authService;
  PremiumIntroductionStore(this._userService, this._authService)
      : super(PremiumIntroductionState()) {
    reset();
  }

  reset() {
    Future(() async {
      _subscribe();

      state = state.copyWith(exception: null);
      state = state.copyWith(
        hasLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
      );
      _userService.fetch().then((value) {
        state = state.copyWith(isPremium: value.isPremium);
      });
      _fetchOfferings().then((value) {
        state = state.copyWith(offerings: value);
      });
    });
  }

  Future<Offerings> _fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings;
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      print(exception);
      rethrow;
    }
  }

  StreamSubscription? _userStreamCanceller;
  StreamSubscription? _authStreamCanceller;
  _subscribe() {
    _userStreamCanceller?.cancel();
    _userStreamCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(isPremium: event.isPremium);
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
    super.dispose();
  }

  /// Return true indicates end of regularllly pattern.
  /// Return false indicates not regulally pattern.
  /// Return value is used to display the completion snackbar
  Future<bool> restore() async {
    try {
      final purchaserInfo = await Purchases.restoreTransactions();
      final entitlements = purchaserInfo.entitlements.all[premiumEntitlements];
      analytics.logEvent(name: "proceed_restore_purchase_info", parameters: {
        "entitlements": entitlements?.identifier,
        "isActivated": entitlements?.isActive,
      });
      if (entitlements != null && entitlements.isActive) {
        analytics.logEvent(name: "done_restore_purchase_info", parameters: {
          "entitlements": entitlements.identifier,
        });
        await callUpdatePurchaseInfo(purchaserInfo);
        state = state.copyWith(isCompletedRestore: true);
        return Future.value(true);
      }
      analytics.logEvent(name: "undone_restore_purchase_info", parameters: {
        "entitlements": entitlements?.identifier,
        "isActivated": entitlements?.isActive,
      });
      throw UserDisplayedError("以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください");
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(name: "catched_restore_exception", parameters: {
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
      analytics
          .logEvent(name: "catched_restore_anonymous_exception", parameters: {
        "exception_type": exception.runtimeType.toString(),
      });
      errorLogger.recordError(exception, stack);
      rethrow;
    }
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

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  showHUD() {
    state = state.copyWith(isLoading: true);
  }

  hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}
