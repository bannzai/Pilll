import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/domain/record/components/notification_bar/discount_price_deadline.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar/premium_trial_guide.dart';
import 'package:pilll/domain/record/components/notification_bar/premium_trial_limit.dart';
import 'package:pilll/domain/record/components/notification_bar/recommend_signup.dart';
import 'package:pilll/domain/record/components/notification_bar/recommend_signup_premium.dart';
import 'package:pilll/domain/record/components/notification_bar/rest_duration.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

class NotificationBar extends HookWidget {
  final RecordPageState parameter;

  NotificationBar(this.parameter);
  @override
  Widget build(BuildContext context) {
    final body = _body(context);
    if (body != null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        color: PilllColors.secondary,
        child: body,
      );
    }

    return Container();
  }

  Widget? _body(BuildContext context) {
    final state = useProvider(notificationBarStateProvider(parameter));
    final store = useProvider(notificationBarStoreProvider(parameter));
    if (!state.isPremium) {
      if (!state.isExpiredDiscountEntitlements) {
        if (!state.isTrial) {
          final trialDeadlineDate = state.trialDeadlineDate;
          if (trialDeadlineDate != null) {
            // NOTE: watch state
            final isOverDiscountDeadline =
                useProvider(isOverDiscountDeadlineProvider(trialDeadlineDate));
            if (!isOverDiscountDeadline) {
              return DiscountPriceDeadline(
                  trialDeadlineDate: trialDeadlineDate,
                  onTap: () {
                    showPremiumIntroductionSheet(context);
                  });
            }
          }
        }
      }

      final restDurationNotification = state.restDurationNotification;
      if (restDurationNotification != null) {
        return RestDurationNotificationBar(
            restDurationNotification: restDurationNotification);
      }

      if (!state.isLinkedLoginProvider) {
        if (state.totalCountOfActionForTakenPill >= 7) {
          if (!state.recommendedSignupNotificationIsAlreadyShow) {
            return RecommendSignupNotificationBar(
              onTap: () {
                analytics.logEvent(name: "tapped_signup_notification_bar");
                showSigninSheet(
                  context,
                  SigninSheetStateContext.recordPage,
                  (linkAccount) {
                    analytics.logEvent(
                        name: "signined_account_from_notification_bar");
                    showDemographyPageIfNeeded(context);
                  },
                );
              },
              onClose: () {
                analytics.logEvent(
                    name: "record_page_signing_notification_closed");
                store.closeRecommendedSignupNotification();
              },
            );
          }
        }
      }

      if (!state.isTrial) {
        if (state.trialDeadlineDate == null) {
          if (!state.premiumTrialGuideNotificationIsClosed) {
            return PremiumTrialGuideNotificationBar(
              onTap: () {
                showPremiumTrialModal(context, () {
                  showPremiumTrialCompleteModalPreDialog(context);
                });
              },
              onClose: () {
                store.closePremiumTrialNotification();
              },
            );
          }
        }
      }

      final premiumTrialLimit = state.premiumTrialLimit;
      if (premiumTrialLimit != null) {
        return PremiumTrialLimitNotificationBar(
            premiumTrialLimit: premiumTrialLimit);
      }
    } else {
      if (state.shownRecommendSignupNotificationForPremium) {
        return RecommendSignupForPremiumNotificationBar();
      }

      final restDurationNotification = state.restDurationNotification;
      if (restDurationNotification != null) {
        return RestDurationNotificationBar(
            restDurationNotification: restDurationNotification);
      }
    }
  }
}
