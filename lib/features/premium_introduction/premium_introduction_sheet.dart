import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_header.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/features/premium_introduction/components/premium_user_thanks.dart';
import 'package:pilll/features/premium_introduction/components/purchase_buttons.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/links.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumIntroductionSheet extends HookConsumerWidget {
  const PremiumIntroductionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueGroup.group2(
      ref.watch(purchaseOfferingsProvider),
      ref.watch(premiumAndTrialProvider),
    ).when(
      data: (data) => PremiumIntroductionSheetBody(
        offerings: data.t1,
        premiumAndTrial: data.t2,
      ),
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () {
          ref.invalidate(purchaseOfferingsProvider);
          ref.invalidate(refreshAppProvider);
        },
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

class PremiumIntroductionSheetBody extends HookConsumerWidget {
  final Offerings offerings;
  final PremiumAndTrial premiumAndTrial;

  const PremiumIntroductionSheetBody({
    Key? key,
    required this.offerings,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringType = ref.watch(currentOfferingTypeProvider(premiumAndTrial));
    final monthlyPackage = ref.watch(monthlyPackageProvider(premiumAndTrial));
    final annualPackage = ref.watch(annualPackageProvider(premiumAndTrial));
    final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(premiumAndTrial.discountEntitlementDeadlineDate));
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider(premiumAndTrial));

    final isLoading = useState(false);

    return HUD(
      shown: isLoading.value,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          color: PilllColors.white,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: !premiumAndTrial.isPremium && !isOverDiscountDeadline
                      ? const DecorationImage(
                          image: AssetImage("images/premium_background.png"),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                width: MediaQuery.of(context).size.width,
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PremiumIntroductionHeader(),
                    if (premiumAndTrial.isPremium) ...[
                      const SizedBox(height: 32),
                      const PremiumUserThanksRow(),
                    ],
                    if (!premiumAndTrial.isPremium) ...[
                      const Text(
                        "\\ 値上げ前の今がチャンス /",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.japanese,
                          fontSize: 20,
                          color: TextColor.discount,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (premiumAndTrial.hasDiscountEntitlement)
                        if (monthlyPremiumPackage != null)
                          PremiumIntroductionDiscountRow(
                            monthlyPremiumPackage: monthlyPremiumPackage,
                            discountEntitlementDeadlineDate: premiumAndTrial.discountEntitlementDeadlineDate,
                          ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "6月以降に価格改定のため",
                            style: TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: TextColor.main,
                            ),
                          ),
                          Text(
                            "「¥600/月」",
                            style: TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: TextColor.main,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      PurchaseButtons(
                        offeringType: offeringType,
                        monthlyPackage: monthlyPackage,
                        annualPackage: annualPackage,
                        isLoading: isLoading,
                      ),
                    ],
                    const SizedBox(height: 24),
                    AlertButton(
                        onPressed: () async {
                          analytics.logEvent(name: "pressed_premium_functions_on_sheet");
                          await launchUrl(Uri.parse(preimumLink));
                        },
                        text: "プレミアム機能を見る"),
                    const SizedBox(height: 24),
                    PremiumIntroductionFotter(
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 7,
                top: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showPremiumIntroductionSheet(BuildContext context) {
  analytics.setCurrentScreen(screenName: "PremiumIntroductionSheet");

  showModalBottomSheet(
    context: context,
    builder: (_) => const PremiumIntroductionSheet(),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
