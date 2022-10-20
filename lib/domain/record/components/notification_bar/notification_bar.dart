import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/components/discount_price_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/components/ended_pill_sheet.dart';
import 'package:pilll/domain/record/components/notification_bar/components/pilll_ads.dart';
import 'package:pilll/domain/record/components/notification_bar/components/premium_trial_begin.dart';
import 'package:pilll/domain/record/components/notification_bar/components/user_survey.dart';
import 'package:pilll/domain/record/components/notification_bar/state_notifier.dart';
import 'package:pilll/domain/record/components/notification_bar/components/premium_trial_limit.dart';
import 'package:pilll/domain/record/components/notification_bar/components/recommend_signup.dart';
import 'package:pilll/domain/record/components/notification_bar/components/recommend_signup_premium.dart';
import 'package:pilll/domain/record/components/notification_bar/components/rest_duration.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet_state.codegen.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/util/datetime/day.dart';

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
    final state = ref.watch(notificationBarStateNotifierProvider);
    final stateNotifier = ref.watch(notificationBarStateNotifierProvider.notifier);
    final discountEntitlementDeadlineDate = state.premiumAndTrial.discountEntitlementDeadlineDate;
    final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate));
    final isJaLocale = ref.watch(isJaLocaleProvider);
    final isAdsDisabled = () {
      if (!isJaLocale) {
        return true;
      }
      final begin = DateTime(2022, 8, 10, 0, 0, 0);
      final end = DateTime(2022, 8, 23, 23, 59, 59);
      return now().isBefore(begin) || now().isAfter(end);
    }();

    // TODO: ある程度数が集まったら消す。テストも書かない
    if (!state.premiumAndTrial.isTrial) {
      if (!state.userClosedSurvey) {
        if (!state.userAnsweredSurvey) {
          return UserSurvey(
            onClose: () => stateNotifier.closeUserSurvey(),
            onTap: () => stateNotifier.openUserSurvey(),
          );
        }
      }
    }

    if (!state.premiumAndTrial.isPremium) {
      final premiumTrialLimit = state.premiumTrialLimit;
      if (premiumTrialLimit != null) {
        return PremiumTrialLimitNotificationBar(premiumTrialLimit: premiumTrialLimit);
      }

      if (state.premiumAndTrial.hasDiscountEntitlement) {
        if (!state.premiumAndTrial.isTrial) {
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

      if (state.premiumAndTrial.isTrial) {
        final restDurationNotification = state.restDurationNotification;
        if (restDurationNotification != null) {
          return RestDurationNotificationBar(restDurationNotification: restDurationNotification);
        }

        if (!state.isLinkedLoginProvider) {
          if (state.totalCountOfActionForTakenPill >= 7) {
            if (!state.recommendedSignupNotificationIsAlreadyShow) {
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
                  stateNotifier.closeRecommendedSignupNotification();
                },
              );
            }
          }
        }

        if (state.latestPillSheetGroup != null && state.latestPillSheetGroup?.activedPillSheet == null) {
          // ピルシートグループが存在していてactivedPillSheetが無い場合はピルシート終了が何かしらの理由がなくなったと見なし終了表示にする
          return EndedPillSheet(
            isPremium: state.premiumAndTrial.isPremium,
            isTrial: state.premiumAndTrial.isTrial,
            trialDeadlineDate: state.premiumAndTrial.trialDeadlineDate,
          );
        }
      } else {
        if (!isAdsDisabled) {
          return const PilllAdsNotificationBar(onClose: null);
        }
      }
    } else {
      if (!state.premiumUserIsClosedAdsMederiPill) {
        if (!isAdsDisabled) {
          return PilllAdsNotificationBar(onClose: () => stateNotifier.closeAds());
        }
      }
      if (state.shownRecommendSignupNotificationForPremium) {
        return const RecommendSignupForPremiumNotificationBar();
      }

      final restDurationNotification = state.restDurationNotification;
      if (restDurationNotification != null) {
        return RestDurationNotificationBar(restDurationNotification: restDurationNotification);
      }

      if (state.latestPillSheetGroup != null && state.latestPillSheetGroup?.activedPillSheet == null) {
        // ピルシートグループが存在していてactivedPillSheetが無い場合はピルシート終了が何かしらの理由がなくなったと見なし終了表示にする
        return EndedPillSheet(
          isPremium: state.premiumAndTrial.isPremium,
          isTrial: state.premiumAndTrial.isTrial,
          trialDeadlineDate: state.premiumAndTrial.trialDeadlineDate,
        );
      }
    }

    return null;
  }
}
