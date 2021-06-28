import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/purchases.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final premiumIntroductionStoreProvider = StateNotifierProvider.autoDispose(
    (ref) => PremiumIntroductionStore(
        ref.watch(userServiceProvider), ref.watch(authServiceProvider)));

class PremiumIntroductionStore extends StateNotifier<PremiumIntroductionState> {
  final UserService _userService;
  final AuthService _authService;
  PremiumIntroductionStore(this._userService, this._authService)
      : super(PremiumIntroductionState()) {
    reset();
  }

  reset() {
    Future(() async {
      _subscribe();

      state = state.copyWith(exception: null, selectedPackage: null);
      state = state.copyWith(
        hasLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
      );
      _userService.fetch().then((value) {
        state = state.copyWith(isPremium: value.isPremium);
      });
      _fetchOfferings().then((value) {
        state = state.copyWith(offerings: value);
        if (state.selectedPackage == null) {
          state = state.copyWith(selectedPackage: state.annualPackage);
        }
      });
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

  StreamSubscription? _userStreamCanceller;
  StreamSubscription? _authStreamCanceller;
  _subscribe() {
    _userStreamCanceller?.cancel();
    _userStreamCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(isPremium: event.isPremium);
    });
    _authStreamCanceller?.cancel();
    _authStreamCanceller = _authService.subscribe().listen((_) {
      state = state.copyWith(
          hasLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
  }

  @override
  void dispose() {
    _userStreamCanceller?.cancel();
    _userStreamCanceller = null;
    super.dispose();
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
      final newException = _mapToDisplayedException(exception);
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

  // See also: https://docs.revenuecat.com/docs/errors
  Exception? _mapToDisplayedException(PlatformException exception) {
    final errorCode = PurchasesErrorHelper.getErrorCode(exception);
    switch (errorCode) {
      case PurchasesErrorCode.unknownError:
        return FormatException(
            "原因不明のエラーが発生しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.purchaseCancelledError:
        // NOTE: This exception indicates that the User has canceled.
        // See more details: https://docs.revenuecat.com/docs/errors#--purchase_cancelled
        // > No action required. The user decided not to proceed with their in-app purchase.
        return null;
      case PurchasesErrorCode.storeProblemError:
        // NOTE: RevenueCat auto retring purchase request on backend services.
        // Pilll must not be handling error message.
        // See more detail: https://docs.revenuecat.com/docs/errors#--store_problem
        // > If everything was working while testing, you shouldn't have to do anything to handle this error in production. RevenueCat will automatically retry any purchase failures so no data is lost.
        // But, return ambigious error message to be the on the safe side
        return FormatException("$storeName でエラーが発生しています。しばらくお時間をおいて再度お試しください");
      case PurchasesErrorCode.purchaseNotAllowedError:
        // NOTE: Maybe simulator or emulators
        // See more details: https://docs.revenuecat.com/docs/errors#--purchase_not_allowed
        return UserDisplayedError("このデバイスで購入が許可されていません");
      case PurchasesErrorCode.purchaseInvalidError:
        // See more details: https://docs.revenuecat.com/docs/errors#-purchase_invalid
        return UserDisplayedError("支払いに失敗しました。有効な支払い方法かどうかをご確認の上再度お試しください");
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        // Maybe missed implement or User references older payment product.
        // See more details: https://docs.revenuecat.com/docs/errors#-product_not_available_for_purchase
        return UserDisplayedError("対象のプランは現在販売しておりません。お手数ですがアプリを再起動の上お試しください");
      case PurchasesErrorCode.productAlreadyPurchasedError:
        // User already has same product. Announcement to restore
        // See more details: https://docs.revenuecat.com/docs/errors#-product_already_purchased
        // > If this occurs in production, make sure the user restores purchases to re-sync any transactions with their current App User Id.
        return UserDisplayedError(
            "すでにプランを購入済みです。この端末で購入情報を復元する場合は「以前購入した方はこちら」から購入情報を復元してくさい");
      case PurchasesErrorCode.receiptAlreadyInUseError:
        return UserDisplayedError(
            '既に購入済み。もくは購入情報は別のユーザーで使用されています。$_accountNameを確認してください');
      case PurchasesErrorCode.invalidReceiptError:
        return UserDisplayedError("不正な購入情報です。購入情報を確かめてください");
      case PurchasesErrorCode.missingReceiptFileError:
        return UserDisplayedError(
            "購入者の情報が存在しません。$_accountName で端末にサインインをした上でお試しください");
      case PurchasesErrorCode.networkError:
        return UserDisplayedError("ネットワーク状態が不安定です。接続状況を確認した上でお試しください。");
      case PurchasesErrorCode.invalidCredentialsError:
        // Maybe developer or store settings error
        // See more details: https://docs.revenuecat.com/docs/errors#---invalid_credentials
        return FormatException(
            "購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.unexpectedBackendResponseError:
        // Maybe RevenueCat incident
        // See more details: https://docs.revenuecat.com/docs/errors#-unexpected_backend_response_error
        return FormatException(
            "現在購入ができません。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.receiptInUseByOtherSubscriberError:
        return UserDisplayedError(
            '購入情報は別のユーザーで使用されています。端末にログインしている$_accountNameを確認してください');
      case PurchasesErrorCode.invalidAppUserIdError:
        return FormatException(
            "ユーザーが確認できませんでした。アプリを再起動の上再度お試しください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.operationAlreadyInProgressError:
        return UserDisplayedError('購入処理が別途進んでおります。お時間をおいて再度ご確認ください');
      case PurchasesErrorCode.unknownBackendError:
        // Maybe RevenueCat incident
        // See more details: https://docs.revenuecat.com/docs/errors#-unknown_backend_error
        return FormatException(
            "現在購入ができません。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
        // Maybe developer setting error on AppStore
        // See more details: https://docs.revenuecat.com/docs/errors#-invalid_apple_subscription_key
        // > In order to provide Subscription Offers you must first generate a subscription key.
        return FormatException(
            "購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.ineligibleError:
        // Invalidate user
        // See more details: https://docs.revenuecat.com/docs/errors#-ineligible_error
        return FormatException(
            "お使いのユーザーでの購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
      case PurchasesErrorCode.insufficientPermissionsError:
        return UserDisplayedError(
            'お使いの $_accountName ではプランへの加入ができません。お支払い情報をご確認の上再度お試しください');
      case PurchasesErrorCode.paymentPendingError:
        return UserDisplayedError(
            '支払いが途中で止まっております。ログイン中の$_accountNameで$storeNameをお確かめくだい');
      case PurchasesErrorCode.invalidSubscriberAttributesError:
        // See more details: https://docs.revenuecat.com/docs/errors#-invalid_subscriber_attributes
        return FormatException(
            "購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
    }
  }

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
        state = state.copyWith(isCompletedRestore: true);
        return Future.value(true);
      }
      analytics.logEvent(name: "undone_restore_purchase_info", parameters: {
        "entitlements": entitlements?.identifier,
        "isActivated": entitlements?.isActive,
      });
      throw UserDisplayedError("以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください");
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(name: "catched_restore_exception", parameters: {
        "code": exception.code,
        "details": exception.details.toString(),
        "message": exception.message
      });
      final newException = _mapToDisplayedException(exception);
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

  String annualPriceString(Package package) {
    final monthlyPrice = package.product.price / 12;
    final monthlyPriceString =
        NumberFormat.simpleCurrency(decimalDigits: 0, name: "JPY")
            .format(monthlyPrice);
    return "${package.product.priceString} ($monthlyPriceString/月)";
  }

  String monthlyPriceString(Package package) {
    return "${package.product.priceString}";
  }

  String get storeName {
    return Platform.isIOS ? "App Store" : "Google Play";
  }

  String get _accountName {
    return Platform.isIOS ? "Apple ID" : "Google アカウント";
  }

  selectedMonthly() {
    final package = state.monthlyPackage;
    if (package == null) {
      throw AssertionError("unexpected monthly package is not exists");
    }
    state = state.copyWith(selectedPackage: package);
  }

  selectedAnnual() {
    final package = state.annualPackage;
    if (package == null) {
      throw AssertionError("unexpected annual package is not exists");
    }
    state = state.copyWith(selectedPackage: package);
  }

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  showHUD() {
    state = state.copyWith(isLoading: true);
  }

  hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}
