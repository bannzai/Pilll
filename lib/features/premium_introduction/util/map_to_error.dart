import 'package:flutter/services.dart';
import 'package:pilll/error/alert_error.dart';
import 'package:pilll/util/platform/platform.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// See also: https://docs.revenuecat.com/docs/errors
Exception? mapToDisplayedException(PlatformException exception) {
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
      return AlertError("このデバイスで購入が許可されていません");
    case PurchasesErrorCode.purchaseInvalidError:
      // See more details: https://docs.revenuecat.com/docs/errors#-purchase_invalid
      return AlertError("支払いに失敗しました。有効な支払い方法かどうかをご確認の上再度お試しください");
    case PurchasesErrorCode.productNotAvailableForPurchaseError:
      // Maybe missed implement or User references older payment product.
      // See more details: https://docs.revenuecat.com/docs/errors#-product_not_available_for_purchase
      return AlertError("対象のプランは現在販売しておりません。お手数ですがアプリを再起動の上お試しください");
    case PurchasesErrorCode.productAlreadyPurchasedError:
      // User already has same product. Announcement to restore
      // See more details: https://docs.revenuecat.com/docs/errors#-product_already_purchased
      // > If this occurs in production, make sure the user restores purchases to re-sync any transactions with their current App User Id.
      return AlertError(
          "すでにプランを購入済みです。この端末で購入情報を復元する場合は「以前購入した方はこちら」から購入情報を復元してくさい");
    case PurchasesErrorCode.receiptAlreadyInUseError:
      return AlertError('既に購入済み。もくは購入情報は別のユーザーで使用されています。$accountNameを確認してください');
    case PurchasesErrorCode.invalidReceiptError:
      return AlertError("不正な購入情報です。購入情報を確かめてください");
    case PurchasesErrorCode.missingReceiptFileError:
      return AlertError("購入者の情報が存在しません。$accountName で端末にサインインをした上でお試しください");
    case PurchasesErrorCode.networkError:
      return AlertError("ネットワーク状態が不安定です。接続状況を確認した上でお試しください。");
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
      return AlertError(
          '購入情報は別のユーザーで使用されています。端末にログインしている$accountNameを確認してください');
    case PurchasesErrorCode.invalidAppUserIdError:
      return FormatException(
          "ユーザーが確認できませんでした。アプリを再起動の上再度お試しください。詳細: ${exception.message}:${exception.details}");
    case PurchasesErrorCode.operationAlreadyInProgressError:
      return AlertError('購入処理が別途進んでおります。お時間をおいて再度ご確認ください');
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
      return AlertError(
          'お使いの $accountName ではプランへの加入ができません。お支払い情報をご確認の上再度お試しください');
    case PurchasesErrorCode.paymentPendingError:
      return AlertError(
          '支払いが途中で止まっております。ログイン中の$accountNameで$storeNameをお確かめくだい');
    case PurchasesErrorCode.invalidSubscriberAttributesError:
      // See more details: https://docs.revenuecat.com/docs/errors#-invalid_subscriber_attributes
      return FormatException(
          "購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
    case PurchasesErrorCode.logOutWithAnonymousUserError:
      return FormatException(
          "ユーザー情報を取得失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
    case PurchasesErrorCode.configurationError:
      return FormatException(
          "購入情報取得に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
    case PurchasesErrorCode.unsupportedError:
      return FormatException(
          "原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}");
  }
}
