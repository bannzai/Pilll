import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/app_store/app_store_review_cards.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/features/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/utils/links.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// 利用開始から約1年になる約1ヶ月前のユーザーへ、割引版の買い切りプランを期間限定で訴求するオファー画面
class LifetimeOfferPage extends HookConsumerWidget {
  final PaywallSource source;
  const LifetimeOfferPage({
    super.key,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).when(
          data: (user) {
            return LifetimeOfferPageBody(
              user: user,
              source: source,
            );
          },
          error: (error, stack) => AlertDialog(
            title: const Text('エラー'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

class LifetimeOfferPageBody extends HookConsumerWidget {
  final User user;
  final PaywallSource source;

  const LifetimeOfferPageBody({
    super.key,
    required this.user,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    final purchase = ref.watch(purchaseProvider);
    final lifetimeDiscountPackage = ref.watch(lifetimeDiscountPackageProvider);
    final lifetimePremiumPackage = ref.watch(lifetimePremiumPackageProvider);
    final lifetimeDiscountRate = ref.watch(lifetimeDiscountRateProvider);
    final usageDays = ref.watch(lifetimeOfferUsageDaysProvider);
    // 買い切り購入後もサブスクリプションの自動更新は止まらないため、月額・年額で課金中のユーザーには事前の解約を促す
    final isActiveSubscriber = user.isPremium && ref.watch(isLifetimePurchasedProvider).valueOrNull != true;

    if (lifetimeDiscountPackage == null) {
      return const ScaffoldIndicator();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: TextColor.main),
          onPressed: () {
            analytics.logEvent(
              name: 'lifetime_offer_close_button_tapped',
            );
            // オファーは表示期限まで有効でバーから再度開けるため、確認なしで閉じる
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/lifetime_offer_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'いつもご利用ありがとうございます',
                  style: TextStyle(
                    color: TextColor.primary,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (usageDays != null) ...[
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Pilllを使い始めて',
                          style: TextStyle(
                            color: TextColor.main,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: '$usageDays',
                          style: const TextStyle(
                            color: TextColor.primary,
                            fontFamily: FontFamily.number,
                            fontWeight: FontWeight.w700,
                            fontSize: 48,
                          ),
                        ),
                        const TextSpan(
                          text: '日',
                          style: TextStyle(
                            color: TextColor.main,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Text(
                  '長く使ってくださっている方へ\n買い切りプランのご案内です',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TextColor.main,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '期間限定の特別価格です！',
                  style: TextStyle(
                    color: TextColor.primary,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const LifetimeOfferCountdownText(),
                const SizedBox(height: 28),
                if (isActiveSubscriber) ...[
                  const LifetimeOfferSubscriptionCancelNotice(),
                  const SizedBox(height: 16),
                ],
                LifetimeOfferPriceCard(
                  lifetimeDiscountPackage: lifetimeDiscountPackage,
                  lifetimePremiumPackage: lifetimePremiumPackage,
                  lifetimeDiscountRate: lifetimeDiscountRate,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: '期間限定の価格で購入する',
                      onPressed: () async {
                        analytics.logEvent(
                          name: 'pressed_lifetime_purchase_button',
                          parameters: {'paywall_source': source.value},
                        );
                        if (isLoading.value) return;
                        isLoading.value = true;

                        try {
                          final shouldShowCompleteDialog = await purchase(lifetimeDiscountPackage, source: source);
                          if (shouldShowCompleteDialog) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return PremiumCompleteDialog(
                                    onClose: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            }
                          }
                        } catch (error) {
                          debugPrint('caused purchase error for $error');
                          if (context.mounted) {
                            showErrorAlert(context, error);
                          }
                        } finally {
                          isLoading.value = false;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const AppStoreReviewCards(),
                const SizedBox(height: 24),
                AlertButton(
                  onPressed: () async {
                    analytics.logEvent(
                      name: 'pressed_premium_functions_on_sheet',
                    );
                    await launchUrl(Uri.parse(preimumLink));
                  },
                  text: L.viewPremiumFeatures,
                ),
                const SizedBox(height: 16),
                PremiumIntroductionFooter(isLoading: isLoading, backgroundColor: Colors.transparent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 表示期限までの残り時間を毎秒更新でカウントダウン表示するテキスト
///
/// ページ全体の毎秒再ビルドを避けるため、tick由来のProviderはこのWidget内でのみwatchする。
class LifetimeOfferCountdownText extends ConsumerWidget {
  const LifetimeOfferCountdownText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingDuration = ref.watch(lifetimeOfferRemainingDurationProvider);
    if (remainingDuration.inSeconds <= 0) {
      return Container();
    }
    return Text(
      '残り ${lifetimeOfferCountdownString(remainingDuration)}',
      style: const TextStyle(
        color: TextColor.primary,
        fontFamily: FontFamily.number,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    );
  }
}

/// 割引価格と通常価格・割引率を対比して見せる価格カード
class LifetimeOfferPriceCard extends StatelessWidget {
  final Package lifetimeDiscountPackage;
  final Package? lifetimePremiumPackage;
  final double? lifetimeDiscountRate;

  const LifetimeOfferPriceCard({
    super.key,
    required this.lifetimeDiscountPackage,
    required this.lifetimePremiumPackage,
    required this.lifetimeDiscountRate,
  });

  @override
  Widget build(BuildContext context) {
    final lifetimeDiscountRate = this.lifetimeDiscountRate;
    final lifetimePremiumPackage = this.lifetimePremiumPackage;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 2, color: AppColors.primary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                L.lifetimePlan,
                style: const TextStyle(
                  color: TextColor.main,
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (lifetimeDiscountRate != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    '${lifetimeDiscountRate.toInt()}％OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // 通常価格が取得できない場合、通貨が異なるユーザーへ日本円のフォールバック値を出すと誤解を招くため非表示にする
          if (lifetimeDiscountRate != null && lifetimePremiumPackage != null) ...[
            Text(
              '通常価格 ${lifetimePremiumPackage.storeProduct.priceString}',
              style: const TextStyle(
                color: TextColor.gray,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            lifetimeDiscountPackage.storeProduct.priceString,
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.number,
              fontWeight: FontWeight.w800,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            L.lifetimePlanDescription,
            style: const TextStyle(
              color: TextColor.gray,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// 月額・年額プランで課金中のユーザーへ、買い切り購入前にサブスクリプションの解約を促す注意文言
class LifetimeOfferSubscriptionCancelNotice extends StatelessWidget {
  const LifetimeOfferSubscriptionCancelNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(width: 1, color: AppColors.danger),
      ),
      child: const Text(
        '月額・年額プランをご利用中の方へ\n買い切りプランを購入しても、月額・年額プランは自動でキャンセルされません。ご購入後にプランの解約をお願いします。',
        style: TextStyle(
          color: AppColors.danger,
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

Future<void> showLifetimeOfferPage(
  BuildContext context, {
  required PaywallSource source,
}) async {
  analytics.logScreenView(screenName: 'LifetimeOfferPage');
  analytics.logEvent(
    name: 'paywall_viewed',
    parameters: {'paywall_source': source.value},
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => LifetimeOfferPage(
        source: source,
      ),
    ),
  );
}
