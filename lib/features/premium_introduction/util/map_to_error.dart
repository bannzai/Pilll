import 'package:flutter/services.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/platform/platform.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// See also: https://docs.revenuecat.com/docs/errors
Exception? mapToDisplayedException(PlatformException exception) {
  final errorCode = PurchasesErrorHelper.getErrorCode(exception);
  switch (errorCode) {
    case PurchasesErrorCode.unknownError:
      return FormatException(
        L.purchaseErrorUnknownError(exception.message ?? '', exception.details),
      );
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
      return FormatException(L.purchaseErrorStoreProblemError(storeName));
    case PurchasesErrorCode.purchaseNotAllowedError:
      // NOTE: Maybe simulator or emulators
      // See more details: https://docs.revenuecat.com/docs/errors#--purchase_not_allowed
      return AlertError(L.purchaseErrorPurchaseNotAllowedError);
    case PurchasesErrorCode.purchaseInvalidError:
      // See more details: https://docs.revenuecat.com/docs/errors#-purchase_invalid
      return AlertError(L.purchaseErrorPurchaseInvalidError);
    case PurchasesErrorCode.productNotAvailableForPurchaseError:
      // Maybe missed implement or User references older payment product.
      // See more details: https://docs.revenuecat.com/docs/errors#-product_not_available_for_purchase
      return AlertError(L.purchaseErrorProductNotAvailableForPurchaseError);
    case PurchasesErrorCode.productAlreadyPurchasedError:
      // User already has same product. Announcement to restore
      // See more details: https://docs.revenuecat.com/docs/errors#-product_already_purchased
      // > If this occurs in production, make sure the user restores purchases to re-sync any transactions with their current App User Id.
      return AlertError(L.purchaseErrorProductAlreadyPurchasedError);
    case PurchasesErrorCode.receiptAlreadyInUseError:
      return AlertError(L.purchaseErrorReceiptAlreadyInUseError(accountName));
    case PurchasesErrorCode.invalidReceiptError:
      return AlertError(L.purchaseErrorInvalidReceiptError);
    case PurchasesErrorCode.missingReceiptFileError:
      return AlertError(L.purchaseErrorMissingReceiptFileError(accountName));
    case PurchasesErrorCode.networkError:
      return AlertError(L.purchaseErrorNetworkError);
    case PurchasesErrorCode.invalidCredentialsError:
      // Maybe developer or store settings error
      // See more details: https://docs.revenuecat.com/docs/errors#---invalid_credentials
      return FormatException(
        L.purchaseErrorInvalidCredentialsError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.unexpectedBackendResponseError:
      // Maybe RevenueCat incident
      // See more details: https://docs.revenuecat.com/docs/errors#-unexpected_backend_response_error
      return FormatException(
        L.purchaseErrorUnexpectedBackendResponseError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.receiptInUseByOtherSubscriberError:
      return AlertError(
        L.purchaseErrorReceiptInUseByOtherSubscriberError(accountName),
      );
    case PurchasesErrorCode.invalidAppUserIdError:
      return FormatException(
        L.purchaseErrorInvalidAppUserIdError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.operationAlreadyInProgressError:
      return AlertError(L.purchaseErrorOperationAlreadyInProgressError);
    case PurchasesErrorCode.unknownBackendError:
      // Maybe RevenueCat incident
      // See more details: https://docs.revenuecat.com/docs/errors#-unknown_backend_error
      return FormatException(
        L.purchaseErrorUnknownBackendError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
      // Maybe developer setting error on AppStore
      // See more details: https://docs.revenuecat.com/docs/errors#-invalid_apple_subscription_key
      // > In order to provide Subscription Offers you must first generate a subscription key.
      return FormatException(
        L.purchaseErrorInvalidAppleSubscriptionKeyError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.ineligibleError:
      // Invalidate user
      // See more details: https://docs.revenuecat.com/docs/errors#-ineligible_error
      return FormatException(
        L.purchaseErrorIneligibleError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.insufficientPermissionsError:
      return AlertError(
        L.purchaseErrorInsufficientPermissionsError(accountName),
      );
    case PurchasesErrorCode.paymentPendingError:
      return AlertError(
        L.purchaseErrorPaymentPendingError(accountName, storeName),
      );
    case PurchasesErrorCode.invalidSubscriberAttributesError:
      // See more details: https://docs.revenuecat.com/docs/errors#-invalid_subscriber_attributes
      return FormatException(
        L.purchaseErrorInvalidSubscriberAttributesError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.logOutWithAnonymousUserError:
      return FormatException(
        L.purchaseErrorLogOutWithAnonymousUserError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.configurationError:
      return FormatException(
        L.purchaseErrorConfigurationError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.unsupportedError:
      return FormatException(
        L.purchaseErrorUnsupportedError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.emptySubscriberAttributesError:
      return AlertError(
        L.purchaseErrorEmptySubscriberAttributesError(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.productDiscountMissingIdentifierError:
      return FormatException(
        L.purchaseErrorProductDiscountMissingIdentifierError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.unknownNonNativeError:
      return FormatException(
        L.purchaseErrorUnknownNonNativeError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.productDiscountMissingSubscriptionGroupIdentifierError:
      return FormatException(
        L.purchaseErrorProductDiscountMissingSubscriptionGroupIdentifierError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.customerInfoError:
      return FormatException(
        L.purchaseErrorCustomerInfoError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.systemInfoError:
      return FormatException(
        L.purchaseErrorSystemInfoError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.beginRefundRequestError:
      return FormatException(
        L.purchaseErrorBeginRefundRequestError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.productRequestTimeout:
      return FormatException(
        L.purchaseErrorProductRequestTimeout(
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.apiEndpointBlocked:
      return FormatException(
        L.purchaseErrorApiEndpointBlocked(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.invalidPromotionalOfferError:
      return FormatException(
        L.purchaseErrorInvalidPromotionalOfferError(
          exception.code,
          exception.message ?? '',
          exception.details,
        ),
      );
    case PurchasesErrorCode.offlineConnectionError:
      return FormatException(
        L.purchaseErrorOfflineConnectionError(
          exception.message ?? '',
          exception.details,
        ),
      );
  }
}
