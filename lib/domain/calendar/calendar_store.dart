import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/calendar_card_state.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/domain/calendar/calendar_state.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/datetime/date_compare.dart';

final calendarPageStateProvider = StateNotifierProvider<CalendarPageStateStore>(
  (ref) => CalendarPageStateStore(
    ref.watch(menstruationServiceProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(diaryServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(userServiceProvider),
    ref.watch(pillSheetGroupService),
  ),
);

class CalendarPageStateStore extends StateNotifier<CalendarPageState> {
  final MenstruationService _menstruationService;
  final SettingService _settingService;
  final PillSheetService _pillSheetService;
  final DiaryService _diaryService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final UserService _userService;
  final PillSheetGroupService _pillSheetGroupService;

  CalendarPageStateStore(
    this._menstruationService,
    this._settingService,
    this._pillSheetService,
    this._diaryService,
    this._pillSheetModifiedHistoryService,
    this._userService,
    this._pillSheetGroupService,
  ) : super(CalendarPageState(menstruations: [])) {
    _reset();
  }

  void _reset() {
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    Future(() async {
      final menstruations = await _menstruationService.fetchAll();
      final setting = await _settingService.fetch();
      final latestPillSheet = await _pillSheetGroupService.fetchLatest();
      final diaries = await _diaryService.fetchListForMonth(
          state.calendarDataSource[state.todayCalendarIndex]);
      final pillSheetModifiedHistories =
          await _pillSheetModifiedHistoryService.fetchList(
              null,
              CalendarPillSheetModifiedHistoryCardState
                      .pillSheetModifiedHistoriesThreshold +
                  1);
      final user = await _userService.fetch();
      state = state.copyWith(
        menstruations: menstruations,
        setting: setting,
        latestPillSheet: latestPillSheet,
        diariesForMonth: diaries,
        allPillSheetModifiedHistories: pillSheetModifiedHistories,
        isNotYetLoaded: false,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        trialDeadlineDate: user.trialDeadlineDate,
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _latestPillSheetCanceller;
  StreamSubscription? _diariesCanceller;
  StreamSubscription? _pillSheetModifiedHistoryCanceller;
  StreamSubscription? _userCanceller;
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
      state = state.copyWith(diariesForMonth: entities);
    });
    _pillSheetModifiedHistoryCanceller?.cancel();
    _pillSheetModifiedHistoryCanceller = _pillSheetModifiedHistoryService
        .subscribe(CalendarPillSheetModifiedHistoryCardState
                .pillSheetModifiedHistoriesThreshold +
            1)
        .listen((event) {
      state = state.copyWith(allPillSheetModifiedHistories: event);
    });
    _userCanceller?.cancel();
    _userCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        trialDeadlineDate: event.trialDeadlineDate,
      );
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    _settingCanceller?.cancel();
    _latestPillSheetCanceller?.cancel();
    _diariesCanceller?.cancel();
    _pillSheetModifiedHistoryCanceller?.cancel();
    _userCanceller?.cancel();
    super.dispose();
  }

  void updateCurrentCalendarIndex(int index) {
    if (state.currentCalendarIndex == index) {
      return;
    }
    state = state.copyWith(currentCalendarIndex: index);
    final date = state.calendarDataSource[state.currentCalendarIndex];
    _diaryService.fetchListForMonth(date).then((diaries) {
      final ignoredSameMonth = state.diariesForMonth
          .where((element) => !isSameMonth(element.date, date))
          .toList();
      final updated = ignoredSameMonth..addAll(diaries);
      state = state.copyWith(diariesForMonth: updated);
    });
  }

  CalendarCardState cardState(DateTime date) => CalendarCardState(date);
}
