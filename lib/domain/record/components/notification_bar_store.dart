import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar_store_parameter.dart';
import 'package:pilll/domain/record/components/notification_bar_state.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose.family(
  (ref, NotificationBarStoreParameter parameter) =>
      NotificationBarStateStore(parameter, ref.watch(authServiceProvider)),
);

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  final NotificationBarStoreParameter parameter;
  final AuthService _authService;
  NotificationBarStateStore(this.parameter, this._authService)
      : super(
          NotificationBarState(
            pillSheet: parameter.pillSheet,
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
            recommendedSignupNotificationIsAlreadyShow,
        isLinkedLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
      );
      _subscribe();
    });
  }

  StreamSubscription? _authServiceCanceller;
  _subscribe() {
    _authServiceCanceller?.cancel();
    _authServiceCanceller = _authService.subscribe().listen((event) {
      state = state.copyWith(
          isLinkedLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
  }

  Future<void> closeRecommendedSignupNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.recommendedSignupNotificationIsAlreadyShow, true);
    state = state.copyWith(recommendedSignupNotificationIsAlreadyShow: true);
  }
}
