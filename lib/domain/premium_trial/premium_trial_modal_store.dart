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
    state = state.copyWith(isLoading: true);
    Future(() async {
      final storage = await SharedPreferences.getInstance();
      final user = await _userService.fetch();
      this.state = PremiumTrialModalState(
        isTrial: user.isTrial,
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
}
