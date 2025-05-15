import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob.dart';
import 'package:pilll/features/record/components/announcement_bar/components/special_offering.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pilll_ads.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/discount_price_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/ended_pill_sheet.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';
import 'package:pilll/features/record/components/announcement_bar/components/premium_trial_limit.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_premium.dart';
import 'package:pilll/features/record/components/announcement_bar/components/rest_duration.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/remote_config.dart';

class AnnouncementBar extends HookConsumerWidget {
  const AnnouncementBar({super.key});

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
    final firebaseAuthUser = ref.watch(firebaseUserStateProvider).valueOrNull;
    final user = ref.watch(userProvider).valueOrNull;
    final isLinkedLoginProvider = ref.watch(isLinkedProvider);
    final discountEntitlementDeadlineDate = user?.discountEntitlementDeadlineDate;
    final hiddenCountdownDiscountDeadline =
        ref.watch(hiddenCountdownDiscountDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate));
    final isJaLocale = ref.watch(isJaLocaleProvider);
    final pilllAds = ref.watch(pilllAdsProvider).asData?.value;
    final appIsReleased = ref.watch(appIsReleasedProvider).asData?.value == true;
    DateTime? userBeginDate;
    if (kDebugMode) {
      userBeginDate = DateTime(2023, 1, 1);
    } else {
      userBeginDate = firebaseAuthUser?.metadata.creationTime;
    }

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

    if (user == null) {
      return Container();
    }

    // if (kDebugMode) {
    //   return const SpecialOfferingAnnouncementBar();
    // }

    // NOTE: アプリがリリースされていない場合 & ユーザーがプレミアムでない場合は広告を表示する
    if (!appIsReleased && !user.isPremium && Environment.flavor == Flavor.PRODUCTION) {
      return const AdMob();
    }

    if (!user.isPremium) {
      if (user.hasDiscountEntitlement) {
        if (!user.isTrial) {
          if (discountEntitlementDeadlineDate != null) {
            if (!hiddenCountdownDiscountDeadline) {
              return DiscountPriceDeadline(
                  discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
                  onTap: () {
                    analytics.logEvent(name: 'pressed_discount_announcement_bar');
                    showPremiumIntroductionSheet(context);
                  });
            }
          }
        }
      }

      if (latestPillSheetGroup != null && latestPillSheetGroup.activePillSheet == null) {
        // ピルシートグループが存在していてactivedPillSheetが無い場合はピルシート終了が何かしらの理由がなくなったと見なし終了表示にする
        return EndedPillSheet(
          isPremium: user.isPremium,
          isTrial: user.isTrial,
        );
      }

      if (user.isTrial) {
        final premiumTrialLimit = PremiumTrialLimitAnnouncementBar.premiumTrialLimitMessage(user);
        if (premiumTrialLimit != null) {
          return PremiumTrialLimitAnnouncementBar(premiumTrialLimit: premiumTrialLimit);
        }
      } else {
        // !isPremium && !isTrial

        if (!isAdsDisabled && pilllAds != null) {
          return PilllAdsAnnouncementBar(pilllAds: pilllAds, onClose: () => showPremiumIntroductionSheet(context));
        }

        if (userBeginDate != null && daysBetween(userBeginDate, today()) >= 600) {
          return const SpecialOfferingAnnouncementBar();
        }

        return const AdMob();
      }
    } else {
      // user.isPremium
      if (!isLinkedLoginProvider) {
        return const RecommendSignupForPremiumAnnouncementBar();
      }

      final restDurationNotification = RestDurationAnnouncementBar.retrieveRestDurationNotification(latestPillSheetGroup: latestPillSheetGroup);
      if (restDurationNotification != null) {
        return RestDurationAnnouncementBar(restDurationNotification: restDurationNotification);
      }

      if (latestPillSheetGroup != null && latestPillSheetGroup.activePillSheet == null) {
        // ピルシートグループが存在していてactivedPillSheetが無い場合はピルシート終了が何かしらの理由がなくなったと見なし終了表示にする
        return EndedPillSheet(
          isPremium: user.isPremium,
          isTrial: user.isTrial,
        );
      }
    }

    return null;
  }
}
