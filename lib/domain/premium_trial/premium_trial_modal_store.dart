import 'dart:async';

import 'package:pilll/domain/premium_trial/premium_trial_modal_state.codegen.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/database/user.dart';
import 'package:riverpod/riverpod.dart';

final premiumTrialStoreProvider =
    StateNotifierProvider<PremiumTrialModalStateStore, PremiumTrialModalState>(
  (ref) => PremiumTrialModalStateStore(
    ref.watch(userDatastoreProvider),
  ),
);

class PremiumTrialModalStateStore
    extends StateNotifier<PremiumTrialModalState> {
  final UserDatastore _userService;
  PremiumTrialModalStateStore(
    this._userService,
  ) : super(const PremiumTrialModalState()) {
    reset();
  }

  void reset() {
    Future(() async {
      final user = await _userService.fetch();
      this.state = PremiumTrialModalState(
        isLoading: false,
        isTrial: user.isTrial,
        setting: user.setting,
      );
      _subscribe();
    });
  }

  StreamSubscription? _userSubscribeCanceller;
  void _subscribe() {
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.stream().listen((event) {
      state = state.copyWith(isTrial: event.isTrial, setting: event.setting);
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
    final setting = state.setting;
    if (setting == null) {
      throw AssertionError("Unexpected setting is null when start to trial");
    }
    try {
      await _userService.trial(setting);
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      throw UserDisplayedError("エラーが発生しました。通信環境をお確かめのうえ再度お試しください");
    }
  }
}
