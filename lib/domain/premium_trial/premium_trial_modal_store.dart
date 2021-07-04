import 'dart:async';

import 'package:pilll/domain/premium_trial/premium_trial_modal_state.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';

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

  trial() async {
    if (state.isTrial && state.beginTrialDate != null) {
      state = state.copyWith(
          exception: "すでにトライアル中になっています。もし解決しない場合は設定>お問い合わせよりご連絡ください");
      return;
    }
    try {
      await _userService.trial();
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      throw UserDisplayedError("エラーが発生しました。通信環境をお確かめのうえ再度お試しください");
    }
  }
}
