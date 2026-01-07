import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/error_log.dart';

/// RevenueCatのEntitlementInfo.productIdentifierに"lifetime"が含まれるかで判定するProvider
final isLifetimePurchasedProvider = FutureProvider.autoDispose<bool>((ref) async {
  try {
    final customerInfo = await Purchases.getCustomerInfo();
    final premiumEntitlement = customerInfo.entitlements.all[premiumEntitlements];
    if (premiumEntitlement == null || !premiumEntitlement.isActive) {
      return false;
    }
    final productIdentifier = premiumEntitlement.productIdentifier;
    return productIdentifier.toLowerCase().contains('lifetime');
  } catch (e, stack) {
    errorLogger.recordError(e, stack);
    return false;
  }
});
