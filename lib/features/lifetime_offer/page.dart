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

/// 買い切りオファー画面のゴールドアクセントカラー（濃）。CTAグラデーションとバッジに使用する
const _goldDark = Color(0xFFB8913F);

/// 買い切りオファー画面のゴールドアクセントカラー（淡）。CTAグラデーションと見出しに使用する
const _goldLight = Color(0xFFE0BC6E);

/// 買い切りオファー画面の背景のフォールバックカラー。背景画像の読み込み前後の隙間を埋める
const _navyBackground = Color(0xFF2E3E5C);

/// 利用開始から約1年になる約1ヶ月前のユーザーへ、割引版の買い切りプランを一度だけ訴求するオファー画面
class LifetimeOfferPage extends HookConsumerWidget {
  /// お知らせバーの閉じるフラグ。バー経由で開いたときのみ渡され、閉じる確認でtrueにするとバーが永続的に非表示になる。
  /// 起動時自動モーダル経由（null）では確認なしで閉じられる。モーダルを閉じてもオファー自体は失われず、バーから再度開ける。
  final ValueNotifier<bool>? lifetimeOfferIsClosed;
  final PaywallSource source;
  const LifetimeOfferPage({
    super.key,
    required this.lifetimeOfferIsClosed,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).when(
          data: (user) {
            return LifetimeOfferPageBody(
              user: user,
              lifetimeOfferIsClosed: lifetimeOfferIsClosed,
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
  final ValueNotifier<bool>? lifetimeOfferIsClosed;
  final PaywallSource source;

  const LifetimeOfferPageBody({
    super.key,
    required this.user,
    required this.lifetimeOfferIsClosed,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isClosing = useState(false);

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
      backgroundColor: _navyBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: isClosing.value
              ? null
              : () async {
                  analytics.logEvent(
                    name: 'lifetime_offer_close_button_tapped',
                  );

                  // 起動時自動モーダル経由では閉じてもバーから再度開けるため、確認なしで閉じる
                  final lifetimeOfferIsClosed = this.lifetimeOfferIsClosed;
                  if (lifetimeOfferIsClosed == null) {
                    Navigator.of(context).pop();
                    return;
                  }

                  final shouldClose = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          '本当に閉じますか？',
                          style: TextStyle(
                            color: TextColor.main,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        content: const Text(
                          'この特典は今回限りです。閉じると今後受け取ることができません。本当に閉じてもよろしいですか？',
                          style: TextStyle(
                            color: TextColor.main,
                            fontSize: 16,
                          ),
                        ),
                        actions: [
                          AlertButton(
                            onPressed: () async {
                              analytics.logEvent(
                                name: 'lifetime_offer_alert_cancel',
                              );
                              Navigator.of(context).pop(false);
                            },
                            text: '閉じない',
                          ),
                          AlertButton(
                            onPressed: () async {
                              analytics.logEvent(
                                name: 'lifetime_offer_alert_close',
                              );
                              lifetimeOfferIsClosed.value = true;
                              Navigator.of(context).pop(true);
                            },
                            text: '閉じる',
                          ),
                        ],
                      );
                    },
                  );
                  if (shouldClose == true) {
                    isClosing.value = true;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
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
                  'Pilllのご利用がまもなく1年',
                  style: TextStyle(
                    color: _goldLight,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
                if (usageDays != null) ...[
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Pilllを使い始めて',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: '$usageDays',
                          style: const TextStyle(
                            color: _goldLight,
                            fontFamily: FontFamily.number,
                            fontWeight: FontWeight.w700,
                            fontSize: 48,
                          ),
                        ),
                        const TextSpan(
                          text: '日',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  '長くご愛顧いただいている方に\n買い切りプランのご案内をしております',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '今回限りのスペシャル価格です',
                  style: TextStyle(
                    color: _goldLight,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
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
                  child: GestureDetector(
                    onTap: () async {
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
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [_goldLight, _goldDark],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: _goldDark.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              '今回限りの価格で購入する',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontFamily.japanese,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
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
                      PremiumIntroductionFooter(isLoading: isLoading),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1.5, color: _goldDark),
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
                    color: _goldDark,
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
          if (lifetimeDiscountRate != null) ...[
            Text(
              '通常価格 ${lifetimePremiumPackage?.storeProduct.priceString ?? "¥20,000"}',
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
  required ValueNotifier<bool>? lifetimeOfferIsClosed,
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
        lifetimeOfferIsClosed: lifetimeOfferIsClosed,
      ),
    ),
  );
}
