import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar_store_parameter.dart';
import 'package:pilll/domain/record/components/notification_bar_state.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose.family(
  (ref, NotificationBarStoreParameter parameter) =>
      NotificationBarStateStore(parameter),
);

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  final NotificationBarStoreParameter parameter;
  NotificationBarStateStore(this.parameter)
      : super(
          NotificationBarState(
            pillSheet: parameter.pillSheet,
            isLinkedLoginProvider: parameter.isLinkedLoginProvider,
            totalCountOfActionForTakenPill:
                parameter.totalCountOfActionForTakenPill,
          ),
        ) {
    reset();
  }

  reset() {
    Future(() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final recommendedSignupNotificationIsAlreadyShow = sharedPreferences
              .getBool(BoolKey.recommendedSignupNotificationIsAlreadyShow) ??
          false;
      state = state.copyWith(
          recommendedSignupNotificationIsAlreadyShow:
              recommendedSignupNotificationIsAlreadyShow);
    });
  }

  Future<void> closeRecommendedSignupNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.recommendedSignupNotificationIsAlreadyShow, true);
    state = state.copyWith(recommendedSignupNotificationIsAlreadyShow: true);
  }
}
