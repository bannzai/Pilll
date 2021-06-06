import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilll/domain/premium/premium_introduction_state.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final premiumIntroductionStoreProvider =
    StateNotifierProvider.autoDispose((ref) => PremiumIntroductionStore(
          ref.watch(userServiceProvider),
        ));

const _premiumEntitlements = "Premium";

class PremiumIntroductionStore extends StateNotifier<PremiumIntroductionState> {
  final UserService _userService;
  PremiumIntroductionStore(this._userService)
      : super(PremiumIntroductionState()) {
    _reset();
  }

  _reset() {
    Future(() async {
      state = state.copyWith(offerings: await _fetchOfferings());
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

  Future<bool> purchase(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      final premiumEntitlement =
          purchaserInfo.entitlements.all[_premiumEntitlements];
      if (premiumEntitlement == null) {
        return false;
      }
      return premiumEntitlement.isActive;
    } on PlatformException catch (exception, stack) {
      var errorCode = PurchasesErrorHelper.getErrorCode(exception);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(exception);
        print(errorCode);
        return false;
      }
      errorLogger.recordError(exception, stack);
      rethrow;
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      rethrow;
    }
  }

  Future<void> restore() async {
    try {
      final purchaserInfo = await Purchases.restoreTransactions();
      final entitlements = purchaserInfo.entitlements.all[_premiumEntitlements];
      if (entitlements != null && entitlements.isActive) {
        state = state.copyWith(isCompletedRestore: true);
// TODO:
        return;
      }
      throw UserDisplayedError("以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください");
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      rethrow;
    }
  }

  String annualPriceString(Package package) {
    final monthlyPrice = package.product.price / 12;
    final monthlyPriceString =
        NumberFormat.simpleCurrency().format(monthlyPrice);
    return "${package.product.priceString} ($monthlyPriceString/月)";
  }

  String monthlyPriceString(Package package) {
    return "${package.product.priceString}";
  }
}
