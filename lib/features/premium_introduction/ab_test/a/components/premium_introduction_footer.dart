import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PremiumIntroductionFotter extends StatelessWidget {
  final ValueNotifier<bool> isLoading;
  const PremiumIntroductionFotter({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      color: PilllColors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10, fontFamily: FontFamily.japanese, color: TextColor.gray),
                children: [
                  const TextSpan(text: "・プレミアム契約期間は開始日から起算して1ヶ月または1年ごとの自動更新となります\n"),
                  const TextSpan(text: "・"),
                  TextSpan(
                    text: "プライバシーポリシー",
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse("https://bannzai.github.io/Pilll/PrivacyPolicy"), mode: LaunchMode.inAppWebView);
                      },
                  ),
                  const TextSpan(
                    text: " / ",
                  ),
                  TextSpan(
                    text: "利用規約",
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse("https://bannzai.github.io/Pilll/Terms"), mode: LaunchMode.inAppWebView);
                      },
                  ),
                  const TextSpan(
                    text: " / ",
                  ),
                  TextSpan(
                    text: "特定商取引法に基づく表示",
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse("https://bannzai.github.io/Pilll/SpecifiedCommercialTransactionAct"), mode: LaunchMode.inAppWebView);
                      },
                  ),
                  const TextSpan(
                    text: "をご確認のうえ登録してください\n",
                  ),
                  const TextSpan(
                    text: "・プレミアム契約期間の終了日の24時間以上前に解約しない限り契約期間が自動更新されます\n",
                  ),
                  TextSpan(
                    text: "・購入後、自動更新の解約は$storeNameアプリのアカウント設定で行えます。(アプリ内から自動更新の解約は行なえません)。",
                  ),
                  TextSpan(
                    text: "詳細はこちら",
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse("https://pilll.wraptas.site/b10fd76f1d2246d286ad5cff03f22940"), mode: LaunchMode.inAppWebView);
                      },
                  ),
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
                    const SnackBar(
                      duration: Duration(
                        seconds: 2,
                      ),
                      content: Text("購入情報を復元しました"),
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) showErrorAlert(context, error);
              } finally {
                isLoading.value = false;
              }
            },
            child: const Text(
              '以前購入した方はこちら',
              style: TextStyle(
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
      analytics.logEvent(
          name: "catched_restore_exception",
          parameters: {"code": exception.code, "details": exception.details.toString(), "message": exception.message});
      final newException = mapToDisplayedException(exception);
      if (newException == null) {
        return Future.value(false);
      }
      errorLogger.recordError(exception, stack);
      throw newException;
    } catch (exception, stack) {
      analytics.logEvent(name: "catched_restore_anonymous_exception", parameters: {
        "exception_type": exception.runtimeType.toString(),
      });
      errorLogger.recordError(exception, stack);
      rethrow;
    }
  }
}
