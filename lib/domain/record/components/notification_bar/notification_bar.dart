import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/components/discount_price_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/components/ended_pill_sheet.dart';
import 'package:pilll/domain/record/components/notification_bar/components/premium_trial_begin.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar/components/premium_trial_limit.dart';
import 'package:pilll/domain/record/components/notification_bar/components/recommend_signup.dart';
import 'package:pilll/domain/record/components/notification_bar/components/recommend_signup_premium.dart';
import 'package:pilll/domain/record/components/notification_bar/components/rest_duration.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet.dart';
import 'package:pilll/domain/sign_in/sign_in_sheet_state.codegen.dart';
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
    final state = ref.watch(notificationBarStoreProvider);
    final store = ref.watch(notificationBarStoreProvider.notifier);
    final discountEntitlementDeadlineDate = state.premiumAndTrial.discountEntitlementDeadlineDate;
    final isOverDiscountDeadline = ref.watch(isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate));

    if (!state.premiumAndTrial.isPremium) {
      final premiumTrialLimit = state.premiumTrialLimit;
      if (premiumTrialLimit != null) {
        return PremiumTrialLimitNotificationBar(premiumTrialLimit: premiumTrialLimit);
      }

      if (!state.premiumTrialBeginAnouncementIsClosed) {
        if (state.premiumAndTrial.isTrial) {
          final beginTrialDate = state.premiumAndTrial.beginTrialDate;
          if (beginTrialDate != null) {
            final between = daysBetween(beginTrialDate, now());
            if (between <= 3) {
              return PremiumTrialBegin(latestDay: (30 - between), store: store);
            }
          }
        }
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
                store.closeRecommendedSignupNotification();
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
