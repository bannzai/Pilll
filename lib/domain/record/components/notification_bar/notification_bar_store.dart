import 'dart:async';

import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationBarStoreProvider = StateNotifierProvider.autoDispose.family(
  (ref, RecordPageState parameter) => NotificationBarStateStore(
    parameter,
    ref.watch(authServiceProvider),
  ),
);
final notificationBarStateProvider = Provider.autoDispose.family(
  (ref, RecordPageState parameter) =>
      ref.watch(notificationBarStoreProvider(parameter).state),
);

class NotificationBarStateStore extends StateNotifier<NotificationBarState> {
  final RecordPageState parameter;
  final AuthService _authService;
  NotificationBarStateStore(this.parameter, this._authService)
      : super(
          NotificationBarState(
            pillSheet: parameter.entity,
            totalCountOfActionForTakenPill:
                parameter.totalCountOfActionForTakenPill,
            isPremium: parameter.isPremium,
            isTrial: parameter.isTrial,
            trialDeadlineDate: parameter.trialDeadlineDate,
            premiumTrialGuideNotificationIsClosed:
                parameter.premiumTrialGuideNotificationIsClosed,
            recommendedSignupNotificationIsAlreadyShow:
                parameter.recommendedSignupNotificationIsAlreadyShow,
          ),
        ) {
    reset();
  }

  reset() {
    Future(() async {
      state = state.copyWith(
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

  @override
  dispose() {
    _authServiceCanceller?.cancel();
    _authServiceCanceller = null;
    super.dispose();
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
}
