import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.codegen.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose<
    NotificationBarStateStore, NotificationBarState>(
  (ref) => NotificationBarStateStore(
    ref.watch(notificationBarStateProvider),
  ),
);
final notificationBarStateProvider = StateProvider.autoDispose((ref) {
  final parameter = ref.watch(recordPageAsyncStateProvider).value!;
  return NotificationBarState(
    latestPillSheetGroup: parameter.pillSheetGroup,
    totalCountOfActionForTakenPill: parameter.totalCountOfActionForTakenPill,
    premiumAndTrial: parameter.premiumAndTrial,
    isLinkedLoginProvider: parameter.isLinkedLoginProvider,
    premiumTrialGuideNotificationIsClosed:
        parameter.premiumTrialGuideNotificationIsClosed,
    premiumTrialBeginAnouncementIsClosed:
        parameter.premiumTrialBeginAnouncementIsClosed,
    recommendedSignupNotificationIsAlreadyShow:
        parameter.recommendedSignupNotificationIsAlreadyShow,
  );
});

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  NotificationBarStateStore(NotificationBarState state) : super(state);

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

  Future<void> closePremiumTrialBeginNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.premiumTrialBeginAnouncementIsClosed, true);
    state = state.copyWith(premiumTrialBeginAnouncementIsClosed: true);
  }
}
