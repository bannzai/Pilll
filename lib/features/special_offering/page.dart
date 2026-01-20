import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/app_store/app_store_review_cards.dart';
import 'package:pilll/features/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/features/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/utils/links.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialOfferingPage extends HookConsumerWidget {
  final ValueNotifier<bool> specialOfferingIsClosed;
  const SpecialOfferingPage({super.key, required this.specialOfferingIsClosed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).when(
          data: (user) {
            return SpecialOfferingPageBody(
              user: user,
              specialOfferingIsClosed: specialOfferingIsClosed,
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
  final ValueNotifier<bool> specialOfferingIsClosed;

  const SpecialOfferingPageBody({
    super.key,
    required this.user,
    required this.specialOfferingIsClosed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isClosing = useState(false);

    final purchase = ref.watch(purchaseProvider);
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider);
    final annualSpecialOfferingPackage = ref.watch(
      annualSpecialOfferingPackageProvider,
    );

    if (annualSpecialOfferingPackage == null || monthlyPremiumPackage == null) {
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
                        name: 'special_offering_close_button_tapped',
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
                                    name: 'special_offering_alert_cancel',
                                  );
                                  Navigator.of(context).pop(false);
                                },
                                text: '閉じない',
                              ),
                              AlertButton(
                                onPressed: () async {
                                  analytics.logEvent(
                                    name: 'special_offering_alert_close',
                                  );
                                  specialOfferingIsClosed.value = true;
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
                      const Text(
                        '今回だけの特別価格でプレミアム機能をゲット！',
                        style: TextStyle(
                          color: TextColor.main,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnnualPurchaseButton(
                        annualPackage: annualSpecialOfferingPackage,
                        monthlyPackage: monthlyPremiumPackage,
                        monthlyPremiumPackage: monthlyPremiumPackage,
                        offeringType: OfferingType.specialOffering,
                        onTap: (package) async {
                          if (isLoading.value) return;
                          isLoading.value = true;

                          try {
                            final shouldShowCompleteDialog = await purchase(
                              package,
                            );
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
                            name: 'pressed_premium_functions_on_sheet',
                          );
                          await launchUrl(Uri.parse(preimumLink));
                        },
                        text: L.viewPremiumFeatures,
                      ),
                      const SizedBox(height: 20),
                      const AppStoreReviewCards(),
                      const SizedBox(height: 24),
                      PremiumIntroductionFooter(isLoading: isLoading),
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
