import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/ab_test/c/components/features.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_header.dart';
import 'package:pilll/features/premium_introduction/components/premium_user_thanks.dart';
import 'package:pilll/features/premium_introduction/components/purchase_buttons.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/links.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumIntroductionSheetC extends HookConsumerWidget {
  const PremiumIntroductionSheetC({super.key});

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
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider(user));

    final isLoading = useState(false);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
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
                          const SizedBox(height: 12),
                          if (monthlyPremiumPackage != null)
                            PurchaseButtons(
                              offeringType: offeringType,
                              monthlyPackage: monthlyPackage,
                              annualPackage: annualPackage,
                              monthlyPremiumPackage: monthlyPremiumPackage,
                              isLoading: isLoading,
                            ),
                        ],
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: PremiumIntroductionFeatures(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AlertButton(
                            onPressed: () async {
                              analytics.logEvent(name: 'pressed_premium_functions_on_sheet2');
                              await launchUrl(Uri.parse(preimumLink));
                            },
                            text: L.viewPremiumFeatures,
                          ),
                        ),
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
