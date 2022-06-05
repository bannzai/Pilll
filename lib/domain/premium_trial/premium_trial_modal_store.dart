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
  final UserDatastore _userDatastore;
  PremiumTrialModalStateStore(
    this._userDatastore,
  ) : super(const PremiumTrialModalState()) {
    reset();
  }

  void reset() {
    Future(() async {
      final user = await _userDatastore.fetch();
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
    _userSubscribeCanceller = _userDatastore.stream().listen((event) {
      state = state.copyWith(isTrial: event.isTrial, setting: event.setting);
    });
  }

  @override
  void dispose() {
    _userSubscribeCanceller?.cancel();
    super.dispose();
  }

  void handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  void showHUD() {
    state = state.copyWith(isLoading: true);
  }

  void hideHUD() {
    state = state.copyWith(isLoading: false);
  }

  void trial() async {
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
      await _userDatastore.trial(setting);
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      throw UserDisplayedError("エラーが発生しました。通信環境をお確かめのうえ再度お試しください");
    }
  }
}
