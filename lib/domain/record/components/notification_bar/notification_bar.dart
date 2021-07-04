import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store_parameter.dart';
import 'package:pilll/domain/record/components/notification_bar/premium_trial_guide.dart';
import 'package:pilll/domain/record/components/notification_bar/recommend_signup.dart';
import 'package:pilll/domain/record/components/notification_bar/recommend_signup_premium.dart';
import 'package:pilll/domain/record/components/notification_bar/rest_duration.dart';

class NotificationBar extends HookWidget {
  final NotificationBarStoreParameter parameter;

  NotificationBar(this.parameter);
  @override
  Widget build(BuildContext context) {
    final body = _body(context);
    if (body != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: PilllColors.secondary,
        child: body,
      );
    }

    return Container();
  }

  Widget? _body(BuildContext context) {
    final store = useProvider(notificationBarStoreProvider(parameter));
    final state = useProvider(notificationBarStoreProvider(parameter).state);
    if (!state.isPremium) {
      final restDurationNotification = state.restDurationNotification;
      if (restDurationNotification != null) {
        return RestDurationNotificationBar(
            restDurationNotification: restDurationNotification);
      }

      if (!state.isLinkedLoginProvider) {
        if (state.totalCountOfActionForTakenPill >= 7) {
          if (!state.recommendedSignupNotificationIsAlreadyShow) {
            return RecommendSignupNotificationBar(store: store);
          }
        }
      }

      if (!state.isTrial) {
        if (state.trialDeadlineDate == null) {
          if (!state.premiumTrialGuideNotificationIsClosed) {
            return PremiumTrialGuideNotificationBar(store: store);
          }
        }
      }

      final premiumTrialLimit = state.premiumTrialLimit;
      if (premiumTrialLimit != null) {
        return Center(
          child: Text(premiumTrialLimit,
              style: FontType.assistingBold.merge(TextColorStyle.white)),
        );
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
