import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/util/map_to_error.dart';
import 'package:pilll/entity/alert_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumIntroductionFooterStateStore {
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
        return Future.value(true);
      }
      analytics.logEvent(name: "undone_restore_purchase_info", parameters: {
        "entitlements": entitlements?.identifier,
        "isActivated": entitlements?.isActive,
      });
      throw AlertError("以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください");
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
}
