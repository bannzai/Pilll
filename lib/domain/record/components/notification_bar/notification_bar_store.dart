import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose
    .family<NotificationBarStateStore, NotificationBarState, RecordPageState>(
  (ref, parameter) => NotificationBarStateStore(
    parameter,
  ),
);
final notificationBarStateProvider = Provider.autoDispose.family(
  (ref, RecordPageState parameter) =>
      ref.watch(notificationBarStoreProvider(parameter)),
);

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  final RecordPageState parameter;
  NotificationBarStateStore(this.parameter)
      : super(
          NotificationBarState(
            latestPillSheetGroup: parameter.pillSheetGroup,
            totalCountOfActionForTakenPill:
                parameter.totalCountOfActionForTakenPill,
            isPremium: parameter.isPremium,
            isTrial: parameter.isTrial,
            hasDiscountEntitlement: parameter.hasDiscountEntitlement,
            isAlreadyShowAnnouncementSupportedMultilplePillSheet:
                parameter.isAlreadyShowAnnouncementSupportedMultilplePillSheet,
            beginTrialDate: parameter.beginTrialDate,
            trialDeadlineDate: parameter.trialDeadlineDate,
            discountEntitlementDeadlineDate:
                parameter.discountEntitlementDeadlineDate,
            isLinkedLoginProvider: parameter.isLinkedLoginProvider,
            recommendPremiumPlainInTrialIsAlreadyClose:
                parameter.recommendPremiumPlainInTrialIsAlreadyClose,
            premiumTrialGuideNotificationIsClosed:
                parameter.premiumTrialGuideNotificationIsClosed,
            recommendedSignupNotificationIsAlreadyShow:
                parameter.recommendedSignupNotificationIsAlreadyShow,
          ),
        );
  Future<void> closeRecommendedPremiumPlainInTrial() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.recommendPremiumPlainInTrialIsAlreadyClose, true);
    state = state.copyWith(recommendPremiumPlainInTrialIsAlreadyClose: true);
  }

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

  Future<void>
      setTrueIsAlreadyShowAnnouncementSupportedMultilplePillSheet() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.isAlreadyShowAnnouncementSupportedMultilplePillSheet, true);
    state = state.copyWith(
        isAlreadyShowAnnouncementSupportedMultilplePillSheet: true);
  }
}
