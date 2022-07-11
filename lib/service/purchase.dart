import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/app/secret.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/util/environment.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/database/user.dart';

final purchaseServiceProvider = Provider((ref) => PurchaseService());

class PurchaseService {
  Future<Offerings> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings;
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      debugPrint(exception);
      rethrow;
    }
  }
}

const premiumEntitlements = "Premium";

Future<void> callUpdatePurchaseInfo(PurchaserInfo info) async {
  analytics.logEvent(name: "start_update_purchase_info");
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    errorLogger.recordError(
        "unexpected uid is not found when purchase info is update",
        StackTrace.current);
    return;
  }

  final userDatastore = UserDatastore(DatabaseConnection(uid));
  final premiumEntitlement = info.entitlements.all[premiumEntitlements];
  try {
    analytics.logEvent(name: "call_update_purchase_info");
    await userDatastore.updatePurchaseInfo(
      isActivated: premiumEntitlement?.isActive,
      entitlementIdentifier: premiumEntitlement?.identifier,
      premiumPlanIdentifier: premiumEntitlement?.productIdentifier,
      purchaseAppID: info.originalAppUserId,
      activeSubscriptions: info.activeSubscriptions,
      originalPurchaseDate: info.originalPurchaseDate,
    );
    analytics.logEvent(name: "end_update_purchase_info");
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}

Future<void> syncPurchaseInfo() async {
  analytics.logEvent(name: "start_sync_purchase_info");
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    errorLogger.recordError(
        "unexpected uid is not found when purchase info to sync",
        StackTrace.current);
    return;
  }

  PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
  final premiumEntitlement =
      purchaserInfo.entitlements.all[premiumEntitlements];
  final isActivated =
      premiumEntitlement == null ? false : premiumEntitlement.isActive;

  try {
    final userDatastore = UserDatastore(DatabaseConnection(uid));
    analytics.logEvent(name: "call_service_sync_purchase_info");
    await userDatastore.syncPurchaseInfo(isActivated: isActivated);
    analytics.logEvent(name: "end_sync_purchase_info");
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}

Future<void> initializePurchase(String uid) async {
  await Purchases.setDebugLogsEnabled(Environment.isDevelopment);
  await Purchases.setup(Secret.revenueCatPublicAPIKey, appUserId: uid);
  Purchases.addPurchaserInfoUpdateListener(callUpdatePurchaseInfo);
  await syncPurchaseInfo();
}
