import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:pilll/components/app_store/app_store_review_cards.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
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
import 'package:pilll/features/premium_introduction/components/lifetime_discount_comparison.dart';
import 'package:pilll/features/error/page.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/links.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumIntroductionSheet extends HookConsumerWidget {
  const PremiumIntroductionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueGroup.group2(
      ref.watch(purchaseOfferingsProvider),
      ref.watch(userProvider),
    ).when(
      data: (data) => PremiumIntroductionSheetBody(
        offerings: data.$1,
        user: data.$2,
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
  final User user;

  const PremiumIntroductionSheetBody({
    super.key,
    required this.offerings,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringType = ref.watch(currentOfferingTypeProvider(user));
    final monthlyPackage = ref.watch(monthlyPackageProvider(user));
    final annualPackage = ref.watch(annualPackageProvider(user));
    final lifetimePackage = ref.watch(lifetimePackageProvider(user));
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider);
    final lifetimeDiscountRate = ref.watch(lifetimeDiscountRateProvider);

    final isLoading = useState(false);

    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (context, scrollController) {
        return HUD(
          shown: isLoading.value,
          child: Scaffold(
            body: Container(
              padding: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              color: AppColors.white,
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
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 100, top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PremiumIntroductionHeader(),
                        if (user.isPremium) ...[
                          const SizedBox(height: 32),
                          const PremiumUserThanksRow(),
                        ],
                        if (!user.isPremium) ...[
                          if (user.hasDiscountEntitlement)
                            if (monthlyPremiumPackage != null)
                              PremiumIntroductionDiscountRow(
                                monthlyPremiumPackage: monthlyPremiumPackage,
                                discountEntitlementDeadlineDate: user.discountEntitlementDeadlineDate,
                              ),
                          if (lifetimeDiscountRate != null && lifetimePackage != null && offeringType == OfferingType.limited) ...[
                            const SizedBox(height: 24),
                            const LifetimeDiscountComparison(),
                          ],
                          const SizedBox(height: 12),
                          if (monthlyPremiumPackage != null && monthlyPackage != null && annualPackage != null)
                            PurchaseButtons(
                              offeringType: offeringType,
                              monthlyPackage: monthlyPackage,
                              annualPackage: annualPackage,
                              lifetimePackage: lifetimePackage,
                              monthlyPremiumPackage: monthlyPremiumPackage,
                              isLoading: isLoading,
                            ),
                        ],
                        const SizedBox(height: 24),
                        AlertButton(
                          onPressed: () async {
                            analytics.logEvent(name: 'pressed_premium_functions_on_sheet');
                            await launchUrl(Uri.parse(preimumLink));
                          },
                          text: L.viewPremiumFeatures,
                        ),

                        // NOTE:  remoteconfigがうまく動いてない説があるので、一旦このifごと消す
                        // if (isJaLocale && remoteConfigParameter.premiumIntroductionShowsAppStoreReviewCard) ...[
                        const SizedBox(height: 24),
                        const AppStoreReviewCards(),
                        const SizedBox(height: 24),
                        PremiumIntroductionFooter(
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
      },
    );
  }
}

Future<void> showPremiumIntroductionSheet(BuildContext context) async {
  analytics.setCurrentScreen(screenName: 'PremiumIntroductionSheet');

  await showModalBottomSheet(
    context: context,
    builder: (_) => const PremiumIntroductionSheet(),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
