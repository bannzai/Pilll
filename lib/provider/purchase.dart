import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/secret/secret.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/premium_introduction/util/map_to_error.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/environment.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/remote_config.dart';

enum OfferingType { discount, specialOffering, premium }

extension OfferingTypeFunction on OfferingType {
  String get identifier {
    switch (this) {
      case OfferingType.discount:
        return 'Discount';
      case OfferingType.specialOffering:
        return 'Premium';
      case OfferingType.premium:
        return 'Premium3';
    }
  }
}

final _purchaseServiceProvider = Provider((ref) => PurchaseService());
final purchaseOfferingsProvider = FutureProvider((ref) => ref.watch(_purchaseServiceProvider).fetchOfferings());
final currentOfferingTypeProvider = Provider.family.autoDispose((ref, User user) {
  final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: user.discountEntitlementDeadlineDate));
  if (!user.hasDiscountEntitlement) {
    return OfferingType.premium;
  }
  if (isOverDiscountDeadline) {
    return OfferingType.premium;
  } else {
    return OfferingType.discount;
  }
});
final currentOfferingPackagesProvider = Provider.family.autoDispose<List<Package>, User>((ref, User user) {
  final currentOfferingType = ref.watch(currentOfferingTypeProvider(user));
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[currentOfferingType.identifier];
  if (offering != null) {
    return offering.availablePackages;
  }
  return [];
});
final annualPackageProvider = Provider.family.autoDispose((ref, User user) {
  final currentOfferingPackages = ref.watch(currentOfferingPackagesProvider(user));
  return currentOfferingPackages.firstWhereOrNull((element) => element.packageType == PackageType.annual);
});
final monthlyPackageProvider = Provider.family.autoDispose((ref, User user) {
  final currentOfferingPackages = ref.watch(currentOfferingPackagesProvider(user));
  return currentOfferingPackages.firstWhereOrNull((element) => element.packageType == PackageType.monthly);
});
final lifetimePackageProvider = Provider.family.autoDispose((ref, User user) {
  final currentOfferingPackages = ref.watch(currentOfferingPackagesProvider(user));
  return currentOfferingPackages.firstWhereOrNull((element) => element.packageType == PackageType.lifetime);
});
final monthlyPremiumPackageProvider = Provider.autoDispose((ref) {
  const premiumPackageOfferingType = OfferingType.premium;
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[premiumPackageOfferingType.identifier];
  if (offering == null) {
    return null;
  }
  return offering.availablePackages.firstWhereOrNull((element) => element.packageType == PackageType.monthly);
});
final annualSpecialOfferingPackageProvider = Provider.autoDispose((ref) {
  const specialOfferingPackageOfferingType = OfferingType.specialOffering;
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[specialOfferingPackageOfferingType.identifier];
  if (offering == null) {
    return null;
  }
  return offering.availablePackages.firstWhereOrNull((element) => element.packageType == PackageType.annual);
});
final monthlySpecialOfferingPackageProvider = Provider.autoDispose((ref) {
  const specialOfferingPackageOfferingType = OfferingType.specialOffering;
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[specialOfferingPackageOfferingType.identifier];
  if (offering == null) {
    return null;
  }
  return offering.availablePackages.firstWhereOrNull((element) => element.packageType == PackageType.monthly);
});
final lifetimeDiscountPackageProvider = Provider.autoDispose((ref) {
  const limitedPackageOfferingType = OfferingType.discount;
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[limitedPackageOfferingType.identifier];
  if (offering == null) {
    return null;
  }
  return offering.availablePackages.firstWhereOrNull((element) => element.packageType == PackageType.lifetime);
});
final lifetimePremiumPackageProvider = Provider.autoDispose((ref) {
  const premiumPackageOfferingType = OfferingType.premium;
  final offering = ref.watch(purchaseOfferingsProvider).valueOrNull?.all[premiumPackageOfferingType.identifier];
  if (offering == null) {
    return null;
  }
  return offering.availablePackages.firstWhereOrNull((element) => element.packageType == PackageType.lifetime);
});
final lifetimeDiscountRateProvider = Provider.autoDispose<double?>((ref) {
  final appIsReleased = ref.watch(appIsReleasedProvider).valueOrNull ?? false;
  if (!appIsReleased) {
    return null;
  }

  final lifetimeDiscount = ref.watch(lifetimeDiscountPackageProvider);
  final lifetimePremium = ref.watch(lifetimePremiumPackageProvider);

  if (lifetimeDiscount == null || lifetimePremium == null) {
    return null;
  }

  final discountePrice = lifetimeDiscount.storeProduct.price;
  final premiumPrice = lifetimePremium.storeProduct.price;

  if (premiumPrice <= 0) {
    return null;
  }

  final discountRate = ((premiumPrice - discountePrice) / premiumPrice) * 100;
  return discountRate;
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
        throw AssertionError(L.unexpectedPremiumEntitlementsIsNotExists);
      }
      if (!premiumEntitlement.isActive) {
        throw AlertError(L.purchaseErrorPurchasePendingError);
      }
      await callUpdatePurchaseInfo(purchaserInfo);
      return Future.value(true);
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(
          name: 'catched_purchase_exception',
          parameters: {'code': exception.code, 'details': exception.details.toString(), 'message': exception.message});
      final newException = mapToDisplayedException(exception);
      if (newException == null) {
        return Future.value(false);
      }
      errorLogger.recordError(exception, stack);
      throw newException;
    } catch (exception, stack) {
      analytics.logEvent(name: 'catched_purchase_anonymous', parameters: {
        'exception_type': exception.runtimeType.toString(),
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
      debugPrint('[bannzai] ${offerings.all}');
      return offerings;
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      debugPrint(exception.toString());
      rethrow;
    }
  }
}

const premiumEntitlements = 'Premium';

Future<void> callUpdatePurchaseInfo(CustomerInfo info) async {
  analytics.logEvent(name: 'start_update_purchase_info');
  final uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    errorLogger.recordError('unexpected uid is not found when purchase info is update', StackTrace.current);
    return;
  }

  final updatePurchaseInfo = UpdatePurchaseInfo(DatabaseConnection(uid));
  final premiumEntitlement = info.entitlements.all[premiumEntitlements];
  try {
    analytics.logEvent(name: 'call_update_purchase_info');
    await updatePurchaseInfo(
      isActivated: premiumEntitlement?.isActive,
      entitlementIdentifier: premiumEntitlement?.identifier,
      premiumPlanIdentifier: premiumEntitlement?.productIdentifier,
      purchaseAppID: info.originalAppUserId,
      activeSubscriptions: info.activeSubscriptions,
      originalPurchaseDate: info.originalPurchaseDate,
    );
    analytics.logEvent(name: 'end_update_purchase_info');
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}

Future<void> syncPurchaseInfo() async {
  analytics.logEvent(name: 'start_sync_purchase_info');
  final uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    errorLogger.recordError('unexpected uid is not found when purchase info to sync', StackTrace.current);
    return;
  }

  final purchaserInfo = await Purchases.getCustomerInfo();
  final premiumEntitlement = purchaserInfo.entitlements.all[premiumEntitlements];
  final isActivated = premiumEntitlement == null ? false : premiumEntitlement.isActive;

  try {
    final syncPurchaseInfo = SyncPurchaseInfo(DatabaseConnection(uid));
    analytics.logEvent(name: 'call_service_sync_purchase_info');
    await syncPurchaseInfo(isActivated: isActivated);
    analytics.logEvent(name: 'end_sync_purchase_info');
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}

Future<void> initializePurchase(String uid) async {
  await Purchases.setLogLevel(Environment.isDevelopment ? LogLevel.debug : LogLevel.info);
  Purchases.configure(PurchasesConfiguration(Secret.revenueCatPublicAPIKey)..appUserID = uid);
  Purchases.addCustomerInfoUpdateListener(callUpdatePurchaseInfo);
  await syncPurchaseInfo();
}

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
