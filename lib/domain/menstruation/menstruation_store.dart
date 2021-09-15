import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card_state.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/domain/menstruation/menstruation_state.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationsStoreProvider = StateNotifierProvider(
  (ref) => MenstruationStore(
    menstruationService: ref.watch(menstruationServiceProvider),
    diaryService: ref.watch(diaryServiceProvider),
    settingService: ref.watch(settingServiceProvider),
    pillSheetService: ref.watch(pillSheetServiceProvider),
    userService: ref.watch(userServiceProvider),
    pillSheetGroupService: ref.watch(pillSheetGroupServiceProvider),
  ),
);

class MenstruationStore extends StateNotifier<MenstruationState> {
  final MenstruationService menstruationService;
  final DiaryService diaryService;
  final SettingService settingService;
  final PillSheetService pillSheetService;
  final UserService userService;
  final PillSheetGroupService pillSheetGroupService;
  MenstruationStore({
    required this.menstruationService,
    required this.diaryService,
    required this.settingService,
    required this.pillSheetService,
    required this.userService,
    required this.pillSheetGroupService,
  }) : super(MenstruationState()) {
    _reset();
  }

  void _reset() {
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    Future(() async {
      final menstruations = await menstruationService.fetchAll();
      final diaries = await diaryService.fetchListAround90Days(today());
      final setting = await settingService.fetch();
      final latestPillSheetGroup = await pillSheetGroupService.fetchLatest();
      final user = await userService.fetch();
      state = state.copyWith(
        entities: menstruations,
        diariesForMonth: diaries,
        isNotYetLoaded: false,
        setting: setting,
        latestPillSheetGroup: latestPillSheetGroup,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        trialDeadlineDate: user.trialDeadlineDate,
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _diaryCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _pillSheetGroupCanceller;
  StreamSubscription? _userCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        menstruationService.subscribeAll().listen((entities) {
      state = state.copyWith(entities: entities);
    });
    _diaryCanceller?.cancel();
    _diaryCanceller = diaryService.subscribe().listen((entities) {
      state = state.copyWith(diariesForMonth: entities);
    });
    _settingCanceller?.cancel();
    _settingCanceller = settingService.subscribe().listen((setting) {
      state = state.copyWith(setting: setting);
    });
    _pillSheetGroupCanceller?.cancel();
    _pillSheetGroupCanceller =
        pillSheetGroupService.subscribeForLatest().listen((pillSheet) {
      state = state.copyWith(latestPillSheetGroup: pillSheet);
    });
    _userCanceller?.cancel();
    _userCanceller = userService.subscribe().listen((user) {
      state = state.copyWith(
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        trialDeadlineDate: user.trialDeadlineDate,
      );
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    _diaryCanceller?.cancel();
    _settingCanceller?.cancel();
    _pillSheetGroupCanceller?.cancel();
    _userCanceller?.cancel();
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

  MenstruationCardState? cardState() {
    final latestMenstruation = state.latestMenstruation;
    if (latestMenstruation != null &&
        latestMenstruation.dateRange.inRange(today())) {
      return MenstruationCardState.record(menstruation: latestMenstruation);
    }
    final latestPillSheetGroup = state.latestPillSheetGroup;
    final setting = state.setting;
    if (latestPillSheetGroup == null ||
        latestPillSheetGroup.pillSheets.isEmpty ||
        setting == null) {
      return null;
    }
    if (setting.pillNumberForFromMenstruation == 0 ||
        setting.durationMenstruation == 0) {
      return null;
    }

    final menstruationDateRanges = scheduledOrInTheMiddleMenstruationDateRanges(
      latestPillSheetGroup,
      setting,
      state.entities,
      12,
    );
    final inTheMiddleDateRanges =
        menstruationDateRanges.where((element) => element.inRange(today()));

    if (inTheMiddleDateRanges.isNotEmpty) {
      return MenstruationCardState.inTheMiddle(
          scheduledDate: inTheMiddleDateRanges.first.begin);
    }

    final futureDateRanges = menstruationDateRanges
        .where((element) => element.begin.isAfter(today()));
    if (futureDateRanges.isNotEmpty) {
      return MenstruationCardState.future(
          nextSchedule: futureDateRanges.first.begin);
    }

    assert(false);
    return null;
  }

  MenstruationHistoryCardState? historyCardState() {
    final latestMenstruation = state.latestMenstruation;
    if (latestMenstruation == null) {
      return null;
    }
    if (state.entities.length == 1 &&
        latestMenstruation.dateRange.inRange(today())) {
      return null;
    }
    return MenstruationHistoryCardState(
      allMenstruations: state.entities,
      latestMenstruation: latestMenstruation,
      isPremium: state.isPremium,
      isTrial: state.isTrial,
      trialDeadlineDate: state.trialDeadlineDate,
    );
  }
}

List<Menstruation> dropInTheMiddleMenstruation(
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
