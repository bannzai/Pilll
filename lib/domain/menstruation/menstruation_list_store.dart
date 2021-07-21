import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/domain/menstruation/menstruation_list_state.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/store/menstruation.dart';

final menstruationListStoreProvider = StateNotifierProvider(
  (ref) => MenstruationListStore(
      menstruationService: ref.watch(menstruationServiceProvider),
      userService: ref.watch(userServiceProvider)),
);

class MenstruationListStore extends StateNotifier<MenstruationListState> {
  final MenstruationService menstruationService;
  final UserService userService;
  MenstruationListStore({
    required this.menstruationService,
    required this.userService,
  }) : super(MenstruationListState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final menstruations = await menstruationService.fetchAll();
      final user = await userService.fetch();
      state = state.copyWith(
        isNotYetLoaded: false,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        allRows: MenstruationHistoryRowState.rows(
            dropLatestMenstruationIfNeeded(menstruations)),
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _userStreamCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        menstruationService.subscribeAll().listen((entities) {
      state = state.copyWith(
          allRows: MenstruationHistoryRowState.rows(
              dropLatestMenstruationIfNeeded(entities)));
    });
    _userStreamCanceller?.cancel();
    _userStreamCanceller = userService.subscribe().listen((user) {
      state = state.copyWith(isPremium: user.isPremium, isTrial: user.isTrial);
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    _userStreamCanceller?.cancel();
    super.dispose();
  }
}
