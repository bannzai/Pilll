import 'dart:async';

import 'package:pilll/domain/premium_trial/premium_trial_modal_state.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final premiumTrialStoreProvider = StateNotifierProvider(
  (ref) => PremiumTrialModalStateStore(
    ref.watch(userServiceProvider),
  ),
);

class PremiumTrialModalStateStore
    extends StateNotifier<PremiumTrialModalState> {
  final UserService _userService;
  PremiumTrialModalStateStore(
    this._userService,
  ) : super(PremiumTrialModalState()) {
    reset();
  }

  void reset() {
    Future(() async {
      final storage = await SharedPreferences.getInstance();
      final user = await _userService.fetch();
      this.state = PremiumTrialModalState(
        isLoading: false,
        isTrial: user.isTrial,
      );
      _subscribe();
    });
  }

  StreamSubscription? _userSubscribeCanceller;
  void _subscribe() {
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(isTrial: event.isTrial);
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
