import 'dart:async';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card_state.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationsStoreProvider =
    StateNotifierProvider<MenstruationStore, MenstruationState>(
  (ref) => MenstruationStore(
    menstruationDatastore: ref.watch(menstruationDatastoreProvider),
    diaryDatastore: ref.watch(diaryDatastoreProvider),
    settingDatastore: ref.watch(settingDatastoreProvider),
    pillSheetService: ref.watch(pillSheetDatastoreProvider),
    userService: ref.watch(userDatastoreProvider),
    pillSheetGroupService: ref.watch(pillSheetGroupDatastoreProvider),
  ),
);

class MenstruationStore extends StateNotifier<MenstruationState> {
  final MenstruationDatastore menstruationDatastore;
  final DiaryDatastore diaryDatastore;
  final SettingDatastore settingDatastore;
  final PillSheetDatastore pillSheetService;
  final UserDatastore userService;
  final PillSheetGroupDatastore pillSheetGroupService;
  MenstruationStore({
    required this.menstruationDatastore,
    required this.diaryDatastore,
    required this.settingDatastore,
    required this.pillSheetService,
    required this.userService,
    required this.pillSheetGroupService,
  }) : super(MenstruationState()) {
    reset();
  }

  void reset() async {
    state = state.copyWith(exception: null);
    state = state.copyWith(currentCalendarIndex: state.todayCalendarIndex);
    try {
      final menstruations = await menstruationDatastore.fetchAll();
      final diaries = await diaryDatastore.fetchListAround90Days(today());
      final setting = await settingDatastore.fetch();
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
    } catch (exception) {
      state = state.copyWith(exception: exception);
    }
  }

  StreamSubscription? _menstruationCanceller;
  StreamSubscription? _diaryCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _pillSheetGroupCanceller;
  StreamSubscription? _userCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        menstruationDatastore.streamAll().listen((entities) {
      state = state.copyWith(entities: entities);
    });
    _diaryCanceller?.cancel();
    _diaryCanceller = diaryDatastore.stream().listen((entities) {
      state = state.copyWith(diariesForMonth: entities);
    });
    _settingCanceller?.cancel();
    _settingCanceller = settingDatastore.stream().listen((setting) {
      state = state.copyWith(setting: setting);
    });
    _pillSheetGroupCanceller?.cancel();
    _pillSheetGroupCanceller =
        pillSheetGroupService.streamForLatest().listen((pillSheet) {
      state = state.copyWith(latestPillSheetGroup: pillSheet);
    });
    _userCanceller?.cancel();
    _userCanceller = userService.stream().listen((user) {
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

  Future<Menstruation> recordFromToday() async {
    final setting = state.setting;
    if (setting == null) {
      return Future.error(const FormatException("unexpected setting is null"));
    }
    final begin = now();
    var menstruation = Menstruation(
        beginDate: begin,
        endDate: begin.add(Duration(days: setting.durationMenstruation - 1)),
        createdAt: now());

    if (await _canHealthkitDataSave()) {
      final healthKitSampleDataUUID =
          await addMenstruationFlowHealthKitData(menstruation);
      menstruation = menstruation.copyWith(
          healthKitSampleDataUUID: healthKitSampleDataUUID);
    }

    return menstruationDatastore.create(menstruation);
  }

  Future<Menstruation> recordFromYesterday() async {
    final setting = state.setting;
    if (setting == null) {
      return Future.error(const FormatException("unexpected setting is null"));
    }
    final begin = today().subtract(const Duration(days: 1));
    var menstruation = Menstruation(
        beginDate: begin,
        endDate: begin.add(Duration(days: setting.durationMenstruation - 1)),
        createdAt: now());

    if (await _canHealthkitDataSave()) {
      final healthKitSampleDataUUID =
          await addMenstruationFlowHealthKitData(menstruation);
      menstruation = menstruation.copyWith(
          healthKitSampleDataUUID: healthKitSampleDataUUID);
    }

    return menstruationDatastore.create(menstruation);
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

  Future<bool> _canHealthkitDataSave() async {
    if (Platform.isIOS) {
      if (await isHealthDataAvailable()) {
        if (await isAuthorizedReadAndShareToHealthKitData()) {
          return true;
        }
      }
    }
    return false;
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
