import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/calendar_page.dart';
import 'package:pilll/util/datetime/date_compare.dart';

final calendarPageStateProvider = StateNotifierProvider<CalendarPageStateStore>(
  (ref) => CalendarPageStateStore(
    ref.watch(menstruationServiceProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(diaryServiceProvider),
  ),
);

class CalendarPageStateStore extends StateNotifier<CalendarPageState> {
  final MenstruationService _menstruationService;
  final SettingService _settingService;
  final PillSheetService _pillSheetService;
  final DiaryService _diaryService;

  CalendarPageStateStore(
    this._menstruationService,
    this._settingService,
    this._pillSheetService,
    this._diaryService,
  ) : super(CalendarPageState(menstruations: [])) {
    _reset();
  }

  void _reset() {
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    Future(() async {
      final menstruations = await _menstruationService.fetchAll();
      final setting = await _settingService.fetch();
      final latestPillSheet = await _pillSheetService.fetchLast();
      final diaries = await _diaryService.fetchListForMonth(
          state.calendarDataSource[state.todayCalendarIndex]);
      ;
      state = state.copyWith(
        menstruations: menstruations,
        setting: setting,
        latestPillSheet: latestPillSheet,
        diaries: diaries,
        isNotYetLoaded: false,
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _latestPillSheetCanceller;
  StreamSubscription? _diariesCanceller;
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
    _diariesCanceller?.cancel();
    _diariesCanceller = _diaryService.subscribe().listen((entities) {
      state = state.copyWith(diaries: entities);
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    _settingCanceller?.cancel();
    _latestPillSheetCanceller?.cancel();
    _diariesCanceller?.cancel();
    super.dispose();
  }

  void updateCurrentCalendarIndex(int index) {
    if (state.currentCalendarIndex == index) {
      return;
    }
    state = state.copyWith(currentCalendarIndex: index);
    final date = state.calendarDataSource[state.currentCalendarIndex];
    _diaryService.fetchListForMonth(date).then((diaries) {
      final ignoredSameMonth = state.diaries
          .where((element) => !isSameMonth(element.date, date))
          .toList();
      final updated = ignoredSameMonth..addAll(diaries);
      state = state.copyWith(diaries: updated);
    });
  }
}
