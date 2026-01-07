import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/premium_introduction/util/map_to_error.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/platform/platform.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumIntroductionFooter extends StatelessWidget {
  final ValueNotifier<bool> isLoading;
  const PremiumIntroductionFooter({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      color: AppColors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10, fontFamily: FontFamily.japanese, color: TextColor.gray),
                children: [
                  TextSpan(text: L.premiumTermsNotice1),
                  const TextSpan(text: '・'),
                  TextSpan(
                    text: L.privacyPolicy,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse('https://bannzai.github.io/Pilll/PrivacyPolicy'), mode: LaunchMode.inAppBrowserView);
                      },
                  ),
                  const TextSpan(
                    text: ' / ',
                  ),
                  TextSpan(
                    text: L.termsOfService,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse('https://bannzai.github.io/Pilll/Terms'), mode: LaunchMode.inAppBrowserView);
                      },
                  ),
                  const TextSpan(
                    text: ' / ',
                  ),
                  TextSpan(
                    text: L.premiumTermsNotice2,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse('https://bannzai.github.io/Pilll/SpecifiedCommercialTransactionAct'), mode: LaunchMode.inAppBrowserView);
                      },
                  ),
                  TextSpan(
                    text: L.premiumTermsNotice3,
                  ),
                  TextSpan(
                    text: L.autoRenewNotice,
                  ),
                  TextSpan(
                    text: L.cancelAutoRenewInfo(storeName),
                  ),
                  TextSpan(
                    text: L.moreDetails,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse('https://pilll.notion.site/Pilll-b10fd76f1d2246d286ad5cff03f22940?pvs=25'),
                            mode: LaunchMode.inAppBrowserView);
                      },
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10, fontFamily: FontFamily.japanese, color: Colors.white),
                children: [
                  TextSpan(text: L.lifetimePurchaseNotice1),
                  TextSpan(
                    text: L.lifetimePurchaseNotice2,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(subscriptionManagementURL), mode: LaunchMode.inAppBrowserView);
                      },
                  ),
                  TextSpan(text: L.lifetimePurchaseNotice3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              try {
                isLoading.value = true;
                final messenger = ScaffoldMessenger.of(context);
                final shouldShowSnackbar = await _restore();
                if (shouldShowSnackbar) {
                  messenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(
                        seconds: 2,
                      ),
                      content: Text(L.restorePurchase),
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) showErrorAlert(context, error);
              } finally {
                isLoading.value = false;
              }
            },
            child: Text(
              L.previouslyPurchased,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: TextColor.main,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Return true indicates end of regularllly pattern.
  /// Return false indicates not regulally pattern.
  /// Return value is used to display the completion snackbar
  Future<bool> _restore() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      final entitlements = purchaserInfo.entitlements.all[premiumEntitlements];
      analytics.logEvent(name: 'proceed_restore_purchase_info', parameters: {
        'entitlements': entitlements?.identifier,
        'isActivated': entitlements?.isActive,
      });
      if (entitlements != null && entitlements.isActive) {
        analytics.logEvent(name: 'done_restore_purchase_info', parameters: {
          'entitlements': entitlements.identifier,
        });
        await callUpdatePurchaseInfo(purchaserInfo);
        return Future.value(true);
      }
      analytics.logEvent(name: 'undone_restore_purchase_info', parameters: {
        'entitlements': entitlements?.identifier,
        'isActivated': entitlements?.isActive,
      });
      throw AlertError(L.noPreviousPurchaseInfo);
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(
          name: 'catched_restore_exception',
          parameters: {'code': exception.code, 'details': exception.details.toString(), 'message': exception.message});
      final newException = mapToDisplayedException(exception);
      if (newException == null) {
        return Future.value(false);
      }
      errorLogger.recordError(exception, stack);
      throw newException;
    } catch (exception, stack) {
      analytics.logEvent(name: 'catched_restore_anonymous_exception', parameters: {
        'exception_type': exception.runtimeType.toString(),
      });
      errorLogger.recordError(exception, stack);
      rethrow;
    }
  }
}
