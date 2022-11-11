import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pilll_ads.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/components/discount_price_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/components/ended_pill_sheet.dart';
import 'package:pilll/domain/record/components/notification_bar/components/pilll_ads.dart';
import 'package:pilll/domain/record/components/notification_bar/components/user_survey.dart';
import 'package:pilll/domain/record/components/notification_bar/state_notifier.dart';
import 'package:pilll/domain/record/components/notification_bar/components/premium_trial_limit.dart';
import 'package:pilll/domain/record/components/notification_bar/components/recommend_signup.dart';
import 'package:pilll/domain/record/components/notification_bar/components/recommend_signup_premium.dart';
import 'package:pilll/domain/record/components/notification_bar/components/rest_duration.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet_state.codegen.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/keys.dart';

class NotificationBar extends HookConsumerWidget {
  const NotificationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = _body(context, ref);
    if (body != null) {
      return body;
    }

    return Container();
  }

  Widget? _body(BuildContext context, WidgetRef ref) {
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupStreamProvider).requireValue;
    final totalCountOfActionForTakenPill = ref.watch(intSharedPreferencesProvider(IntKey.totalCountOfActionForTakenPill)).valueOrNull ?? 0;
    final premiumAndTrial = ref.watch(premiumAndTrialProvider).requireValue;
    final isLinkedLoginProvider = ref.watch(isLinkedProvider);
    final recommendedSignupNotificationIsAlreadyShow =
        ref.watch(boolSharedPreferencesProvider(BoolKey.recommendedSignupNotificationIsAlreadyShow)).valueOrNull ?? false;
    final recommendedSignupNotificationIsAlreadyShowNotifier =
        ref.watch(boolSharedPreferencesProvider(BoolKey.recommendedSignupNotificationIsAlreadyShow).notifier);
    final userAnsweredSurvey = ref.watch(boolSharedPreferencesProvider(BoolKey.userAnsweredSurvey)).valueOrNull ?? false;
    final userAnsweredSurveyNotifier = ref.watch(boolSharedPreferencesProvider(BoolKey.userAnsweredSurvey).notifier);
    final userClosedSurvey = ref.watch(boolSharedPreferencesProvider(BoolKey.userClosedSurvey)).valueOrNull ?? false;
    final userClosedSurveyNotifier = ref.watch(boolSharedPreferencesProvider(BoolKey.userClosedSurvey).notifier);
    final stateNotifier = ref.watch(notificationBarStateNotifierProvider.notifier);
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

    // TODO: ある程度数が集まったら消す。テストも書かない
    if (!premiumAndTrial.isTrial) {
      if (!userClosedSurvey) {
        if (!userAnsweredSurvey) {
          return UserSurvey(
            onClose: () => userClosedSurveyNotifier.set(true),
            onTap: () => userAnsweredSurveyNotifier.set(true),
          );
        }
      }
    }

    if (!premiumAndTrial.isPremium) {
      final premiumTrialLimit = PremiumTrialLimitNotificationBar.retrievePremiumTrialLimit(premiumAndTrial);
      if (premiumTrialLimit != null) {
        return PremiumTrialLimitNotificationBar(premiumTrialLimit: premiumTrialLimit);
      }

      if (premiumAndTrial.hasDiscountEntitlement) {
        if (!premiumAndTrial.isTrial) {
          if (discountEntitlementDeadlineDate != null) {
            if (!isOverDiscountDeadline) {
              return DiscountPriceDeadline(
                  discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
                  onTap: () {
                    analytics.logEvent(name: "pressed_discount_notification_bar");
                    showPremiumIntroductionSheet(context);
                  });
            }
          }
        }
      }

      if (premiumAndTrial.isTrial) {
        final restDurationNotification = RestDurationNotificationBar.retrieveRestDurationNotification(latestPillSheetGroup: latestPillSheetGroup);
        if (restDurationNotification != null) {
          return RestDurationNotificationBar(restDurationNotification: restDurationNotification);
        }

        if (!isLinkedLoginProvider) {
          if (totalCountOfActionForTakenPill >= 7) {
            if (!recommendedSignupNotificationIsAlreadyShow) {
              return RecommendSignupNotificationBar(
                onTap: () {
                  analytics.logEvent(name: "tapped_signup_notification_bar");
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
          return PilllAdsNotificationBar(pilllAds: pilllAds, onClose: () => showPremiumIntroductionSheet(context));
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
        return const RecommendSignupForPremiumNotificationBar();
      }

      final restDurationNotification = RestDurationNotificationBar.retrieveRestDurationNotification(latestPillSheetGroup: latestPillSheetGroup);
      if (restDurationNotification != null) {
        return RestDurationNotificationBar(restDurationNotification: restDurationNotification);
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
