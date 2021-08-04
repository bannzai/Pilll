import 'dart:async';

import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_state.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pillSheetModifiedHistoryStoreProvider = StateNotifierProvider(
  (ref) => PillSheetModifiedHistoryStateStore(
    ref.watch(userServiceProvider),
  ),
);

class PillSheetModifiedHistoryStateStore
    extends StateNotifier<PillSheetModifiedHistoryState> {
  final UserService _userService;
  PillSheetModifiedHistoryStateStore(
    this._userService,
  ) : super(PillSheetModifiedHistoryState()) {
    reset();
  }

  void reset() {
    state = state.copyWith(isLoading: true);
    Future(() async {
      final storage = await SharedPreferences.getInstance();
      final user = await _userService.fetch();
      this.state = PillSheetModifiedHistoryState(
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        beginTrialDate: user.beginTrialDate,
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
      state = state.copyWith(
          isPremium: event.isPremium,
          isTrial: event.isTrial,
          beginTrialDate: event.beginTrialDate);
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
