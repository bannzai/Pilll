import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pilll_ads.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/discount_price_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/ended_pill_sheet.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';
import 'package:pilll/features/record/components/announcement_bar/components/premium_trial_limit.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_premium.dart';
import 'package:pilll/features/record/components/announcement_bar/components/rest_duration.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

class AnnouncementBar extends HookConsumerWidget {
  const AnnouncementBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = _body(context, ref);
    if (body != null) {
      return body;
    }

    return Container();
  }

  Widget? _body(BuildContext context, WidgetRef ref) {
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupProvider).valueOrNull;
    final totalCountOfActionForTakenPill = ref.watch(intSharedPreferencesProvider(IntKey.totalCountOfActionForTakenPill)).valueOrNull ?? 0;
    final premiumAndTrial = ref.watch(premiumAndTrialProvider).requireValue;
    final isLinkedLoginProvider = ref.watch(isLinkedProvider);
    final recommendedSignupNotificationIsAlreadyShow =
        ref.watch(boolSharedPreferencesProvider(BoolKey.recommendedSignupNotificationIsAlreadyShow)).valueOrNull ?? false;
    final recommendedSignupNotificationIsAlreadyShowNotifier =
        ref.watch(boolSharedPreferencesProvider(BoolKey.recommendedSignupNotificationIsAlreadyShow).notifier);
    final discountEntitlementDeadlineDate = premiumAndTrial.discountEntitlementDeadlineDate;
    final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate));
    final isJaLocale = ref.watch(isJaLocaleProvider);
    final pilllAds = ref.watch(pilllAdsProvider).asData?.value;
    final isAdsDisabled = () {
      if (!kDebugMode) {
        if (!isJaLocale) {
          return true;
        }
      }
      if (pilllAds == null) {
        return true;
      }
      return now().isBefore(pilllAds.startDateTime) || now().isAfter(pilllAds.endDateTime);
    }();

    if (!premiumAndTrial.isPremium) {
      if (premiumAndTrial.hasDiscountEntitlement) {
        if (!premiumAndTrial.isTrial) {
          if (discountEntitlementDeadlineDate != null) {
            if (!isOverDiscountDeadline) {
              return DiscountPriceDeadline(
                  discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
                  onTap: () {
                    analytics.logEvent(name: "pressed_discount_announcement_bar");
                    showPremiumIntroductionSheet(context);
                  });
            }
          }
        }
      }

      if (premiumAndTrial.isTrial) {
        final premiumTrialLimit = PremiumTrialLimitAnnouncementBar.retrievePremiumTrialLimit(premiumAndTrial);
        if (premiumTrialLimit != null) {
          return PremiumTrialLimitAnnouncementBar(premiumTrialLimit: premiumTrialLimit);
        }

        final restDurationNotification = RestDurationAnnouncementBar.retrieveRestDurationNotification(latestPillSheetGroup: latestPillSheetGroup);
        if (restDurationNotification != null) {
          return RestDurationAnnouncementBar(restDurationNotification: restDurationNotification);
        }

        if (!isLinkedLoginProvider) {
          if (totalCountOfActionForTakenPill >= 7) {
            if (!recommendedSignupNotificationIsAlreadyShow) {
              return RecommendSignupAnnouncementBar(
                onTap: () {
                  analytics.logEvent(name: "tapped_signup_announcement_bar");
                  showSignInSheet(
                    context,
                    SignInSheetStateContext.recordPage,
                    null,
                  );
                },
                onClose: () {
                  analytics.logEvent(name: "record_page_signing_notification_closed");
                  recommendedSignupNotificationIsAlreadyShowNotifier.set(true);
                },
              );
            }
          }
        }

        if (latestPillSheetGroup != null && latestPillSheetGroup.activedPillSheet == null) {
          // ピルシートグループが存在していてactivedPillSheetが無い場合はピルシート終了が何かしらの理由がなくなったと見なし終了表示にする
          return EndedPillSheet(
            isPremium: premiumAndTrial.isPremium,
            isTrial: premiumAndTrial.isTrial,
            trialDeadlineDate: premiumAndTrial.trialDeadlineDate,
          );
        }
      } else {
        if (!isAdsDisabled && pilllAds != null) {
          return PilllAdsAnnouncementBar(pilllAds: pilllAds, onClose: () => showPremiumIntroductionSheet(context));
        }
      }
    } else {
      final shownRecommendSignupNotificationForPremium = () {
        if (isLinkedLoginProvider) {
          return false;
        }
        if (!premiumAndTrial.isPremium) {
          return false;
        }
        return true;
      }();

      if (shownRecommendSignupNotificationForPremium) {
        return const RecommendSignupForPremiumAnnouncementBar();
      }

      final restDurationNotification = RestDurationAnnouncementBar.retrieveRestDurationNotification(latestPillSheetGroup: latestPillSheetGroup);
      if (restDurationNotification != null) {
        return RestDurationAnnouncementBar(restDurationNotification: restDurationNotification);
      }

      if (latestPillSheetGroup != null && latestPillSheetGroup.activedPillSheet == null) {
        // ピルシートグループが存在していてactivedPillSheetが無い場合はピルシート終了が何かしらの理由がなくなったと見なし終了表示にする
        return EndedPillSheet(
          isPremium: premiumAndTrial.isPremium,
          isTrial: premiumAndTrial.isTrial,
          trialDeadlineDate: premiumAndTrial.trialDeadlineDate,
        );
      }
    }

    return null;
  }
}
