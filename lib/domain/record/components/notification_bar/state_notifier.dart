import 'dart:async';

import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/shared_preferences.dart';
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
  return NotificationBarState(
    latestPillSheetGroup: ref.watch(latestPillSheetGroupStreamProvider).requireValue,
    totalCountOfActionForTakenPill: ref.watch(intSharedPreferencesProvider(IntKey.totalCountOfActionForTakenPill)).valueOrNull ?? 0,
    premiumAndTrial: ref.watch(premiumAndTrialProvider).requireValue,
    isLinkedLoginProvider: ref.watch(isLinkedProvider),
    recommendedSignupNotificationIsAlreadyShow:
        ref.watch(boolSharedPreferencesProvider(BoolKey.recommendedSignupNotificationIsAlreadyShow)).valueOrNull ?? false,
    userAnsweredSurvey: ref.watch(boolSharedPreferencesProvider(BoolKey.userAnsweredSurvey)).valueOrNull ?? false,
    userClosedSurvey: ref.watch(boolSharedPreferencesProvider(BoolKey.userClosedSurvey)).valueOrNull ?? false,
  );
});

class NotificationBarStateNotifier extends StateNotifier<NotificationBarState> {
  NotificationBarStateNotifier(NotificationBarState state) : super(state);

  Future<void> closeRecommendedSignupNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.recommendedSignupNotificationIsAlreadyShow, true);
    state = state.copyWith(recommendedSignupNotificationIsAlreadyShow: true);
  }

  Future<void> closeUserSurvey() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.userClosedSurvey, true);
    state = state.copyWith(userClosedSurvey: true);
  }

  Future<void> openUserSurvey() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.userAnsweredSurvey, true);
    state = state.copyWith(userAnsweredSurvey: true);
  }
}
