import 'dart:async';

import 'package:pilll/domain/premium_trial/premium_trial_state.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final premiumTrialStoreProvider = StateNotifierProvider(
  (ref) => PremiumTrialStateStore(
    ref.watch(userServiceProvider),
  ),
);

class PremiumTrialStateStore extends StateNotifier<PremiumTrialState> {
  final UserService _userService;
  PremiumTrialStateStore(
    this._userService,
  ) : super(PremiumTrialState()) {
    reset();
  }

  void reset() {
    state = state.copyWith(isLoading: true);
    Future(() async {
      final storage = await SharedPreferences.getInstance();
      final user = await _userService.fetch();
      this.state = PremiumTrialState(
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        isLoading: false,
        isFirstLoadEnded: true,
      );
      _subscribe();
    });
  }

  StreamSubscription? _userSubscribeCanceller;
  void _subscribe() {
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.subscribe().listen((event) {
      state =
          state.copyWith(isPremium: event.isPremium, isTrial: event.isTrial);
    });
  }

  @override
  void dispose() {
    _userSubscribeCanceller?.cancel();
    super.dispose();
  }

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  showHUD() {
    state = state.copyWith(isLoading: true);
  }

  hideHUD() {
    state = state.copyWith(isLoading: false);
  }
}
