import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose.family(
  (ref, RecordPageState parameter) => NotificationBarStateStore(
    parameter,
  ),
);
final notificationBarStateProvider = Provider.autoDispose.family(
  (ref, RecordPageState parameter) =>
      ref.watch(notificationBarStoreProvider(parameter).state),
);

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  final RecordPageState parameter;
  NotificationBarStateStore(this.parameter)
      : super(
          NotificationBarState(
            pillSheet: parameter.pillSheetGroup?.activedPillSheet,
            totalCountOfActionForTakenPill:
                parameter.totalCountOfActionForTakenPill,
            isPremium: parameter.isPremium,
            isTrial: parameter.isTrial,
            hasDiscountEntitlement: parameter.hasDiscountEntitlement,
            trialDeadlineDate: parameter.trialDeadlineDate,
            discountEntitlementDeadlineDate:
                parameter.discountEntitlementDeadlineDate,
            isLinkedLoginProvider: parameter.isLinkedLoginProvider,
            premiumTrialGuideNotificationIsClosed:
                parameter.premiumTrialGuideNotificationIsClosed,
            recommendedSignupNotificationIsAlreadyShow:
                parameter.recommendedSignupNotificationIsAlreadyShow,
          ),
        );
  Future<void> closeRecommendedSignupNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.recommendedSignupNotificationIsAlreadyShow, true);
    state = state.copyWith(recommendedSignupNotificationIsAlreadyShow: true);
  }

  Future<void> closePremiumTrialNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.premiumTrialGuideNotificationIsClosed, true);
    state = state.copyWith(premiumTrialGuideNotificationIsClosed: true);
  }
}
