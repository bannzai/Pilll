import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationsStoreProvider = StateNotifierProvider((ref) =>
    MenstruationStore(
        menstruationService: ref.watch(menstruationServiceProvider),
        diaryService: ref.watch(diaryServiceProvider),
        settingService: ref.watch(settingServiceProvider),
        pillSheetService: ref.watch(pillSheetServiceProvider)));

class MenstruationStore extends StateNotifier<MenstruationState> {
  final MenstruationService menstruationService;
  final DiaryService diaryService;
  final SettingService settingService;
  final PillSheetService pillSheetService;
  MenstruationStore({
    required this.menstruationService,
    required this.diaryService,
    required this.settingService,
    required this.pillSheetService,
  }) : super(MenstruationState()) {
    _reset();
  }

  void _reset() {
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    Future(() async {
      final menstruations = await menstruationService.fetchAll();
      final diaries = await diaryService.fetchListAround90Days(today());
      final setting = await settingService.fetch();
      final latestPillSheet = await pillSheetService.fetchLast();
      state = state.copyWith(
          entities: menstruations,
          diaries: diaries,
          isNotYetLoaded: false,
          setting: setting,
          latestPillSheet: latestPillSheet);
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _diaryCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _pillSheetCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        menstruationService.subscribeAll().listen((entities) {
      state = state.copyWith(entities: entities);
    });
    _diaryCanceller?.cancel();
    _diaryCanceller = diaryService.subscribe().listen((entities) {
      state = state.copyWith(diaries: entities);
    });
    _settingCanceller?.cancel();
    _settingCanceller = settingService.subscribe().listen((setting) {
      state = state.copyWith(setting: setting);
    });
    _pillSheetCanceller?.cancel();
    _pillSheetCanceller =
        pillSheetService.subscribeForLatestPillSheet().listen((pillSheet) {
      state = state.copyWith(latestPillSheet: pillSheet);
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    _diaryCanceller?.cancel();
    _settingCanceller?.cancel();
    _pillSheetCanceller?.cancel();
    super.dispose();
  }

  void updateCurrentCalendarIndex(int index) {
    if (state.currentCalendarIndex == index) {
      return;
    }
    state = state.copyWith(currentCalendarIndex: index);
  }

  Future<Menstruation> recordFromToday() {
    final duration = state.setting?.durationMenstruation;
    if (duration == null) {
      return Future.error(FormatException("unexpected setting is null"));
    }
    final begin = now();
    final menstruation = Menstruation(
        beginDate: begin,
        endDate: begin.add(Duration(days: duration - 1)),
        createdAt: now());
    return menstruationService.create(menstruation);
  }

  Future<Menstruation> recordFromYesterday() {
    final duration = state.setting?.durationMenstruation;
    if (duration == null) {
      return Future.error(FormatException("unexpected setting is null"));
    }
    final begin = today().subtract(Duration(days: 1));
    final menstruation = Menstruation(
        beginDate: begin,
        endDate: begin.add(Duration(days: duration - 1)),
        createdAt: now());
    return menstruationService.create(menstruation);
  }

  int get cardCount {
    final card = cardState();
    if (card == null) {
      return 0;
    }
    final historyCard = historyCardState();
    if (historyCard == null) {
      return [card].length;
    }
    return [card, historyCard].length;
  }

  MenstruationCardState? cardState() {
    final latestMenstruation = state.latestMenstruation;
    if (latestMenstruation != null &&
        latestMenstruation.dateRange.inRange(today())) {
      return MenstruationCardState.record(menstruation: latestMenstruation);
    }
    final latestPillSheet = state.latestPillSheet;
    final setting = state.setting;
    if (latestPillSheet == null || setting == null) {
      return null;
    }
    if (today().isAfter(latestPillSheet.beginingDate)) {
      final matchedScheduledMenstruation = scheduledMenstruationDateRanges(
              latestPillSheet, setting, state.entities, 12)
          .where((element) => element.begin.isAfter(today()));

      if (matchedScheduledMenstruation.isNotEmpty) {
        return MenstruationCardState.schedule(
            scheduleDate: matchedScheduledMenstruation.first.begin);
      }
    }
    return MenstruationCardState.schedule(
        scheduleDate: latestPillSheet.beginingDate
            .add(Duration(days: setting.pillNumberForFromMenstruation - 1)));
  }

  MenstruationHistoryCardState? historyCardState() {
    final latestMenstruation = state.latestMenstruation;
    if (latestMenstruation == null) {
      return null;
    }
    return MenstruationHistoryCardState(state.entities);
  }
}

List<Menstruation> dropLatestMenstruationIfNeeded(
    List<Menstruation> menstruations) {
  final _menstruations = [...menstruations];
  if (_menstruations.isEmpty) {
    return [];
  }
  final latestMenstruation = _menstruations.first;
  if (latestMenstruation.dateRange.inRange(today())) {
    _menstruations.removeAt(0);
  }
  return _menstruations;
}
