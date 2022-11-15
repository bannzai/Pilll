import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/app/secret.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/domain/premium_introduction/util/map_to_error.dart';
import 'package:pilll/error/alert_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/environment.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/provider/user.dart';

enum OfferingType { limited, premium }

extension OfferingTypeFunction on OfferingType {
  String get name {
    switch (this) {
      case OfferingType.limited:
        return "Limited";
      case OfferingType.premium:
        return "Premium";
    }
  }
}

final purchaseServiceProvider = Provider((ref) => PurchaseService());
final purchaseOfferingsProvider = FutureProvider((ref) => ref.watch(purchaseServiceProvider).fetchOfferings());
final currentOfferingTypeProvider = Provider.family.autoDispose((ref, PremiumAndTrial premiumAndTrial) {
  final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(premiumAndTrial.discountEntitlementDeadlineDate));
  if (!premiumAndTrial.hasDiscountEntitlement) {
    return OfferingType.premium;
  }
  if (isOverDiscountDeadline) {
    return OfferingType.premium;
  } else {
    return OfferingType.limited;
  }
});
final currentOfferingPackagesProvider = Provider.family.autoDispose((ref, PremiumAndTrial premiumAndTrial) {
  final currentOfferingType = ref.watch(currentOfferingTypeProvider(premiumAndTrial));
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[currentOfferingType.name];
  if (offering != null) {
    return offering.availablePackages;
  }
  return [];
});
final annualPackageProvider = Provider.family.autoDispose((ref, PremiumAndTrial premiumAndTrial) {
  final currentOfferingPackages = ref.watch(currentOfferingPackagesProvider(premiumAndTrial));
  return currentOfferingPackages.firstWhere((element) => element.packageType == PackageType.annual);
});
final monthlyPackageProvider = Provider.family.autoDispose((ref, PremiumAndTrial premiumAndTrial) {
  final currentOfferingPackages = ref.watch(currentOfferingPackagesProvider(premiumAndTrial));
  return currentOfferingPackages.firstWhere((element) => element.packageType == PackageType.monthly);
});
final monthlyPremiumPackageProvider = Provider.family.autoDispose((ref, PremiumAndTrial premiumAndTrial) {
  const premiumPackageOfferingType = OfferingType.premium;
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[premiumPackageOfferingType.name];
  if (offering == null) {
    return null;
  }
  return offering.availablePackages.firstWhere((element) => element.packageType == PackageType.monthly);
});

final purchaseProvider = Provider((ref) => Purchase());

class Purchase {
  /// Return true indicates end of regularllly pattern.
  /// Return false indicates not regulally pattern.
  /// Return value is used to display the completion page
  Future<bool> call(Package package) async {
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      final premiumEntitlement = purchaserInfo.entitlements.all[premiumEntitlements];
      if (premiumEntitlement == null) {
        throw AssertionError("unexpected premium entitlements is not exists");
      }
      if (!premiumEntitlement.isActive) {
        throw AlertError("課金の有効化が完了しておりません。しばらく時間をおいてからご確認ください");
      }
      await callUpdatePurchaseInfo(purchaserInfo);
      return Future.value(true);
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(
          name: "catched_purchase_exception",
          parameters: {"code": exception.code, "details": exception.details.toString(), "message": exception.message});
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

class PurchaseService {
  Future<Offerings> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings;
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      debugPrint(exception.toString());
      rethrow;
    }
  }
}

const premiumEntitlements = "Premium";

Future<void> callUpdatePurchaseInfo(CustomerInfo info) async {
  analytics.logEvent(name: "start_update_purchase_info");
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    errorLogger.recordError("unexpected uid is not found when purchase info is update", StackTrace.current);
    return;
  }

  final updatePurchaseInfo = UpdatePurchaseInfo(DatabaseConnection(uid));
  final premiumEntitlement = info.entitlements.all[premiumEntitlements];
  try {
    analytics.logEvent(name: "call_update_purchase_info");
    await updatePurchaseInfo(
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
    errorLogger.recordError("unexpected uid is not found when purchase info to sync", StackTrace.current);
    return;
  }

  final purchaserInfo = await Purchases.getCustomerInfo();
  final premiumEntitlement = purchaserInfo.entitlements.all[premiumEntitlements];
  final isActivated = premiumEntitlement == null ? false : premiumEntitlement.isActive;

  try {
    final syncPurchaseInfo = SyncPurchaseInfo(DatabaseConnection(uid));
    analytics.logEvent(name: "call_service_sync_purchase_info");
    await syncPurchaseInfo(isActivated: isActivated);
    analytics.logEvent(name: "end_sync_purchase_info");
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}

Future<void> initializePurchase(String uid) async {
  await Purchases.setDebugLogsEnabled(Environment.isDevelopment);
  Purchases.configure(PurchasesConfiguration(Secret.revenueCatPublicAPIKey)..appUserID = uid);
  Purchases.addCustomerInfoUpdateListener(callUpdatePurchaseInfo);
  await syncPurchaseInfo();
}
