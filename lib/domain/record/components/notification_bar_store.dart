import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar_store_parameter.dart';
import 'package:pilll/domain/record/components/notification_bar_state.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose.family(
  (ref, NotificationBarStoreParameter parameter) => NotificationBarStateStore(
    parameter,
    ref.watch(authServiceProvider),
    ref.watch(userServiceProvider),
  ),
);

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  final NotificationBarStoreParameter parameter;
  final AuthService _authService;
  final UserService _userService;
  NotificationBarStateStore(
      this.parameter, this._authService, this._userService)
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
      final user = await _userService.fetch();
      state = state.copyWith(
        recommendedSignupNotificationIsAlreadyShow:
            recommendedSignupNotificationIsAlreadyShow,
        isLinkedLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
        isTrial: user.isTrial,
        isPremium: user.isPremium,
      );
      _subscribe();
    });
  }

  StreamSubscription? _authServiceCanceller;
  StreamSubscription? _userServiceCanceller;
  _subscribe() {
    _authServiceCanceller?.cancel();
    _authServiceCanceller = _authService.subscribe().listen((event) {
      state = state.copyWith(
          isLinkedLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
    _userServiceCanceller?.cancel();
    _userServiceCanceller = _userService.subscribe().listen((event) {
      state =
          state.copyWith(isPremium: event.isPremium, isTrial: event.isTrial);
    });
  }

  Future<void> closeRecommendedSignupNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        BoolKey.recommendedSignupNotificationIsAlreadyShow, true);
    state = state.copyWith(recommendedSignupNotificationIsAlreadyShow: true);
  }
}
