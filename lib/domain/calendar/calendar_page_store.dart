import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/calendar_card_state.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/util/datetime/date_compare.dart';

final calendarPageStateStoreProvider =
    StateNotifierProvider<CalendarPageStateStore, CalendarPageState>(
  (ref) => CalendarPageStateStore(
    ref.watch(menstruationDatastoreProvider),
    ref.watch(settingDatastoreProvider),
    ref.watch(diaryDatastoreProvider),
    ref.watch(pillSheetModifiedHistoryDatastoreProvider),
    ref.watch(userDatastoreProvider),
    ref.watch(pillSheetGroupDatastoreProvider),
  ),
);

class CalendarPageStateStore extends StateNotifier<CalendarPageState> {
  final MenstruationDatastore _menstruationDatastore;
  final SettingDatastore _settingDatastore;
  final DiaryDatastore _diaryDatastore;
  final PillSheetModifiedHistoryDatastore _pillSheetModifiedHistoryService;
  final UserDatastore _userService;
  final PillSheetGroupDatastore _pillSheetGroupService;

  CalendarPageStateStore(
    this._menstruationDatastore,
    this._settingDatastore,
    this._diaryDatastore,
    this._pillSheetModifiedHistoryService,
    this._userService,
    this._pillSheetGroupService,
  ) : super(CalendarPageState(menstruations: [])) {
    reset();
  }

  void reset() async {
    state = state.copyWith(exception: null);
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    try {
      await Future(() async {
        final menstruations = await _menstruationDatastore.fetchAll();
        final setting = await _settingDatastore.fetch();
        final latestPillSheetGroup = await _pillSheetGroupService.fetchLatest();
        final diaries = await _diaryDatastore.fetchListForMonth(
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
          latestPillSheetGroup: latestPillSheetGroup,
          diariesForMonth: diaries,
          allPillSheetModifiedHistories: pillSheetModifiedHistories,
          isNotYetLoaded: false,
          isPremium: user.isPremium,
          isTrial: user.isTrial,
          trialDeadlineDate: user.trialDeadlineDate,
        );
        _subscribe();
      });
    } catch (exception) {
      state = state.copyWith(exception: exception);
    }
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _latestPillSheetGroupCanceller;
  StreamSubscription? _diariesCanceller;
  StreamSubscription? _pillSheetModifiedHistoryCanceller;
  StreamSubscription? _userCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        _menstruationDatastore.streamAll().listen((entities) {
      state = state.copyWith(menstruations: entities);
    });
    _settingCanceller?.cancel();
    _settingCanceller = _settingDatastore.stream().listen((entity) {
      state = state.copyWith(setting: entity);
    });
    _latestPillSheetGroupCanceller?.cancel();
    _latestPillSheetGroupCanceller =
        _pillSheetGroupService.streamForLatest().listen((entity) {
      state = state.copyWith(latestPillSheetGroup: entity);
    });
    _diariesCanceller?.cancel();
    _diariesCanceller = _diaryDatastore.stream().listen((entities) {
      state = state.copyWith(diariesForMonth: entities);
    });
    _pillSheetModifiedHistoryCanceller?.cancel();
    _pillSheetModifiedHistoryCanceller = _pillSheetModifiedHistoryService
        .stream(CalendarPillSheetModifiedHistoryCardState
                .pillSheetModifiedHistoriesThreshold +
            1)
        .listen((event) {
      state = state.copyWith(allPillSheetModifiedHistories: event);
    });
    _userCanceller?.cancel();
    _userCanceller = _userService.stream().listen((event) {
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
    _latestPillSheetGroupCanceller?.cancel();
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
    _diaryDatastore.fetchListForMonth(date).then((diaries) {
      final ignoredSameMonth = state.diariesForMonth
          .where((element) => !isSameMonth(element.date, date))
          .toList();
      final updated = ignoredSameMonth..addAll(diaries);
      state = state.copyWith(diariesForMonth: updated);
    });
  }

  CalendarCardState cardState(DateTime date) => CalendarCardState(date);

  Future<void> editTakenValue(
    DateTime actualTakenDate,
    PillSheetModifiedHistory history,
    PillSheetModifiedHistoryValue value,
    TakenPillValue takenPillValue,
  ) {
    return updateForEditTakenValue(
      service: _pillSheetModifiedHistoryService,
      actualTakenDate: actualTakenDate,
      history: history,
      value: value,
      takenPillValue: takenPillValue,
    );
  }
}
