import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const premiumEntitlements = "Premium";

Future<void> purchaserInfoUpdated(PurchaserInfo info) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    errorLogger.recordError(
        "unexpected uid is not found when purchase info is update",
        StackTrace.current);
    return;
  }

  final userService = UserService(DatabaseConnection(uid));
  final premiumEntitlement = info.entitlements.all[premiumEntitlements];
  final isActivated =
      premiumEntitlement == null ? false : premiumEntitlement.isActive;
  try {
    await userService.updatePurchaseInfo(
      isActivated: isActivated,
      entitlementIdentifier: premiumEntitlement?.identifier,
      premiumPlanIdentifier: premiumEntitlement?.productIdentifier,
      purchaseAppID: info.originalAppUserId,
      activeSubscriptions: info.activeSubscriptions,
      originalPurchaseDate: info.originalPurchaseDate,
    );
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}
