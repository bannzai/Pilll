import 'dart:async';

import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.codegen.dart';
import 'package:pilll/domain/record/record_page_state_notifier.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/shared_preference.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStateNotifierProvider = StateNotifierProvider.autoDispose<NotificationBarStateNotifier, NotificationBarState>(
  (ref) => NotificationBarStateNotifier(
    ref.watch(notificationBarStateProvider),
  ),
);
final notificationBarStateProvider = Provider.autoDispose((ref) {
  final latestPillSheetGroup = ref.watch(latestPillSheetGroupStreamProvider);
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);

  final sharedPreferencesAsyncValue = ref.watch(sharedPreferenceProvider);
  if (latestPillSheetGroup is AsyncLoading || premiumAndTrial is AsyncLoading || sharedPreferencesAsyncValue is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    final sharedPreferences = sharedPreferencesAsyncValue.value!;
    return NotificationBarState(
      latestPillSheetGroup: latestPillSheetGroup.value,
      totalCountOfActionForTakenPill: sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0,
      premiumAndTrial: premiumAndTrial.value!,
      isLinkedLoginProvider: ref.watch(isLinkedProvider),
      recommendedSignupNotificationIsAlreadyShow: sharedPreferences.getBool(BoolKey.recommendedSignupNotificationIsAlreadyShow) ?? false,
      premiumTrialBeginAnouncementIsClosed: sharedPreferences.getBool(BoolKey.premiumTrialBeginAnouncementIsClosed) ?? false,
      premiumUserIsClosedAdsMederiPill: sharedPreferences.getBool(BoolKey.premiumUserIsClosedAdsMederiPill) ?? false,
      userAnsweredSurvey: sharedPreferences.getBool(BoolKey.userAnsweredSurvey) ?? false,
      userClosedSurvey: sharedPreferences.getBool(BoolKey.userClosedSurvey) ?? false,
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace: stackTrace);
  }
});

class NotificationBarStateNotifier extends StateNotifier<AsyncValue<NotificationBarState>> {
  NotificationBarStateNotifier(AsyncValue<NotificationBarState> state) : super(state);

  Future<void> closeRecommendedSignupNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.recommendedSignupNotificationIsAlreadyShow, true);
    state = state.copyWith(recommendedSignupNotificationIsAlreadyShow: true);
  }

  Future<void> closePremiumTrialBeginNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.premiumTrialBeginAnouncementIsClosed, true);
    state = state.copyWith(premiumTrialBeginAnouncementIsClosed: true);
  }

  Future<void> closeAds() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.premiumUserIsClosedAdsMederiPill, true);
    state = state.copyWith(premiumUserIsClosedAdsMederiPill: true);
  }
}
