import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/special_offering/special_offering_copy_variant.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/app_store/app_store_review_cards.dart';
import 'package:pilll/features/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/features/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/utils/links.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialOfferingPage2 extends HookConsumerWidget {
  final ValueNotifier<bool> specialOfferingIsClosed2;
  final PaywallSource source;
  const SpecialOfferingPage2({
    super.key,
    required this.specialOfferingIsClosed2,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).when(
          data: (user) {
            return SpecialOfferingPageBody(
              user: user,
              specialOfferingIsClosed2: specialOfferingIsClosed2,
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

class SpecialOfferingPageBody extends HookConsumerWidget {
  final User user;
  final ValueNotifier<bool> specialOfferingIsClosed2;
  final PaywallSource source;

  const SpecialOfferingPageBody({
    super.key,
    required this.user,
    required this.specialOfferingIsClosed2,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isClosing = useState(false);

    final purchase = ref.watch(purchaseProvider);
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider);
    final monthlySpecialOfferingPackage = ref.watch(
      monthlySpecialOfferingPackageProvider,
    );
    final copyVariant = SpecialOfferingCopyVariant.fromString(ref.watch(remoteConfigParameterProvider).specialOfferingCopyVariant);

    if (monthlySpecialOfferingPackage == null || monthlyPremiumPackage == null) {
      return const ScaffoldIndicator();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '今回限りの特別オファー',
              style: TextStyle(
                color: TextColor.main,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.japanese,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: isClosing.value
                  ? null
                  : () async {
                      analytics.logEvent(
                        name: 'special_offering_close_button_tapped2',
                      );

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
                                    name: 'special_offering_alert_cancel2',
                                  );
                                  Navigator.of(context).pop(false);
                                },
                                text: '閉じない',
                              ),
                              AlertButton(
                                onPressed: () async {
                                  analytics.logEvent(
                                    name: 'special_offering_alert_close2',
                                  );
                                  specialOfferingIsClosed2.value = true;
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
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage('images/premium_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 40,
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PremiumIntroductionDiscountAppeal(
                        monthlyPremiumPackage: monthlyPremiumPackage,
                      ),
                      const SizedBox(height: 10),
                      SvgPicture.asset('images/arrow_down.svg'),
                      const SizedBox(height: 10),
                      Text(
                        switch (copyVariant) {
                          SpecialOfferingCopyVariant.defaultVariant => '今回だけの特別価格でプレミアム機能をゲット！',
                          SpecialOfferingCopyVariant.scarcity => 'このチャンスは今回限り。\n特別価格でプレミアム機能をゲット！',
                        },
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: TextColor.main,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      MonthlyPurchaseButton(
                        monthlyPackage: monthlySpecialOfferingPackage,
                        onTap: (package) async {
                          analytics.logEvent(
                            name: 'pressed_monthly_purchase_button',
                            parameters: {'paywall_source': source.value, 'copy_variant': copyVariant.value},
                          );
                          if (isLoading.value) return;
                          isLoading.value = true;

                          try {
                            final shouldShowCompleteDialog = await purchase(package, source: source);
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
                      const SizedBox(height: 20),
                      AlertButton(
                        onPressed: () async {
                          analytics.logEvent(
                            name: 'pressed_premium_functions_on_sheet2',
                          );
                          await launchUrl(Uri.parse(preimumLink));
                        },
                        text: L.viewPremiumFeatures,
                      ),
                      const SizedBox(height: 20),
                      const AppStoreReviewCards(),
                      const SizedBox(height: 24),
                      PremiumIntroductionFooter(isLoading: isLoading, backgroundColor: AppColors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> showSpecialOfferingPage2(
  BuildContext context, {
  required PaywallSource source,
  required ValueNotifier<bool> specialOfferingIsClosed2,
  required SpecialOfferingCopyVariant copyVariant,
}) async {
  analytics.logScreenView(screenName: 'SpecialOfferingPage2');
  analytics.logEvent(
    name: 'paywall_viewed',
    parameters: {'paywall_source': source.value, 'copy_variant': copyVariant.value},
  );

  await showModalBottomSheet(
    context: context,
    builder: (_) => SpecialOfferingPage2(
      source: source,
      specialOfferingIsClosed2: specialOfferingIsClosed2,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
  );
}
