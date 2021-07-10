import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_state.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_store_parameter.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/domain/premium_introduction/util/map_to_error.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/purchases.dart';
import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';
import 'package:riverpod/riverpod.dart';

final purchaseButtonsStoreProvider = StateNotifierProvider.family
    .autoDispose((ref, PurchaseButtonsStoreParameter parameter) {
  final trialDeadlineDate = parameter.trialDeadlineDate;
  return PurchaseButtonsStore(
    offerings: parameter.offerings,
    trialDeadlineDate: trialDeadlineDate,
    isOverDiscountDeadline: trialDeadlineDate != null
        ? ref.watch(isOverDiscountDeadlineProvider(trialDeadlineDate))
        : null,
  );
});

class PurchaseButtonsStore extends StateNotifier<PurchaseButtonsState> {
  final Offerings offerings;
  final DateTime? trialDeadlineDate;
  final bool? isOverDiscountDeadline;

  PurchaseButtonsStore({
    required this.offerings,
    required this.trialDeadlineDate,
    required this.isOverDiscountDeadline,
  }) : super(
          PurchaseButtonsState(
            offerings: offerings,
            trialDeadlineDate: trialDeadlineDate,
            isOverDiscountDeadline: isOverDiscountDeadline,
          ),
        );

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
