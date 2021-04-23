import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/calendar_page.dart';

final calendarPageStateProvider = StateNotifierProvider<CalendarPageStateStore>(
    (ref) => CalendarPageStateStore(
          ref.watch(menstruationServiceProvider),
          ref.watch(settingServiceProvider),
          ref.watch(pillSheetServiceProvider),
        ));

class CalendarPageStateStore extends StateNotifier<CalendarPageState> {
  final MenstruationService _menstruationService;
  final SettingService _settingService;
  final PillSheetService _pillSheetService;

  CalendarPageStateStore(
      this._menstruationService, this._settingService, this._pillSheetService)
      : super(CalendarPageState(menstruations: [])) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final menstruations = await _menstruationService.fetchAll();
      final setting = await _settingService.fetch();
      final latestPillSheet = await _pillSheetService.fetchLast();
      state = state.copyWith(
        menstruations: menstruations,
        setting: setting,
        latestPillSheet: latestPillSheet,
        isNotYetLoaded: false,
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _latestPillSheetCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        _menstruationService.subscribeAll().listen((entities) {
      state = state.copyWith(menstruations: entities);
    });
    _settingCanceller?.cancel();
    _settingCanceller = _settingService.subscribe().listen((entity) {
      state = state.copyWith(setting: entity);
    });
    _latestPillSheetCanceller?.cancel();
    _latestPillSheetCanceller =
        _pillSheetService.subscribeForLatestPillSheet().listen((entity) {
      state = state.copyWith(latestPillSheet: entity);
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    _settingCanceller?.cancel();
    _latestPillSheetCanceller?.cancel();
    super.dispose();
  }
}
