import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const premiumEntitlements = "Premium";

void purchaserInfoUpdated(PurchaserInfo info) async {
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
        isActivated, premiumEntitlement?.productIdentifier);
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}
