import 'dart:async';

import 'package:pilll/domain/premium_introduction/util/map_to_error.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/purchases.dart';
import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';

final purchaseButtonsStoreProvider = Provider.family.autoDispose(
  (ref, Offerings offerings) => PurchaseButtonsStore(offerings),
);

class PurchaseButtonsStore extends StateNotifier<Offerings> {
  PurchaseButtonsStore(Offerings state) : super(state);

  List<Package> get _packages {
    final offerings = this.state;
    final currentOffering = offerings.current;
    if (currentOffering != null) {
      return currentOffering.availablePackages;
    }
    return [];
  }

  Package? get annualPackage {
    if (_packages.isEmpty) {
      return null;
    }
    return _packages
        .firstWhere((element) => element.packageType == PackageType.annual);
  }

  Package? get monthlyPackage {
    if (_packages.isEmpty) {
      return null;
    }
    return _packages
        .firstWhere((element) => element.packageType == PackageType.monthly);
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
