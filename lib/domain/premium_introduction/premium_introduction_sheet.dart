import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_header.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/domain/premium_introduction/components/premium_user_thanks.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/links.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumIntroductionSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(premiumIntroductionStoreProvider.notifier);
    final state = ref.watch(premiumIntroductionStateProvider);
    final offerings = state.offerings;
    final offeringType = state.currentOfferingType;
    final monthlyPackage = state.monthlyPackage;
    final annualPackage = state.annualPackage;
    final discountEntitlementDeadlineDate =
        state.discountEntitlementDeadlineDate;
    final isOverDiscountDeadline = ref
        .watch(isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate));
    final monthlyPremiumPackage = state.monthlyPremiumPackage;
    if (state.isNotYetLoad) {
      return const Indicator();
    }

    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
          error: null,
          reload: () => store.reset(),
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
                      image: !state.isPremium && !isOverDiscountDeadline
                          ? const DecorationImage(
                              image:
                                  AssetImage("images/premium_background.png"),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PremiumIntroductionHeader(),
                        if (state.isPremium) ...[
                          const SizedBox(height: 32),
                          PremiumUserThanksRow(),
                        ],
                        if (!state.isPremium) ...[
                          if (state.hasDiscountEntitlement)
                            if (monthlyPremiumPackage != null)
                              PremiumIntroductionDiscountRow(
                                monthlyPremiumPackage: monthlyPremiumPackage,
                                discountEntitlementDeadlineDate:
                                    discountEntitlementDeadlineDate,
                              ),
                          if (offerings != null)
                            if (monthlyPackage != null)
                              if (annualPackage != null) ...[
                                const SizedBox(height: 32),
                                PurchaseButtons(
                                  store: store,
                                  offeringType: offeringType,
                                  monthlyPackage: monthlyPackage,
                                  annualPackage: annualPackage,
                                ),
                              ],
                        ],
                        const SizedBox(height: 24),
                        AlertButton(
                            onPressed: () async {
                              analytics.logEvent(
                                  name: "pressed_premium_functions_on_sheet");
                              await launchUrl(Uri.parse(preimumLink));
                            },
                            text: "プレミアム機能を見る"),
                        const SizedBox(height: 24),
                        PremiumIntroductionFotter(),
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
          )),
    );
  }
}

showPremiumIntroductionSheet(BuildContext context) {
  analytics.setCurrentScreen(screenName: "PremiumIntroductionSheet");

  showModalBottomSheet(
    context: context,
    builder: (_) => PremiumIntroductionSheet(),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
