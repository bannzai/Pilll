import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/domain/menstruation/menstruation_page_async_action.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

import 'history/menstruation_history_card_state.dart';

final menstruationsStoreProvider =
    StateNotifierProvider<MenstruationStore, AsyncValue<MenstruationState>>(
  (ref) => MenstruationStore(
    asyncAction: ref.watch(menstruationPageAsyncActionProvider),
    initialState: ref.watch(menstruationPageStateProvider),
  ),
);

class MenstruationStore extends StateNotifier<AsyncValue<MenstruationState>> {
  final MenstruationPageAsyncAction asyncAction;
  MenstruationStore({
    required this.asyncAction,
    required AsyncValue<MenstruationState> initialState,
  }) : super(initialState);

  MenstruationState get stateValue => state.value!;

  MenstruationCardState? cardState() {
    final latestMenstruation = stateValue.latestMenstruation;
    if (latestMenstruation != null &&
        latestMenstruation.dateRange.inRange(today())) {
      return MenstruationCardState.record(menstruation: latestMenstruation);
    }

    final latestPillSheetGroup = stateValue.latestPillSheetGroup;
    final setting = stateValue.setting;
    if (latestPillSheetGroup == null ||
        latestPillSheetGroup.pillSheets.isEmpty) {
      return null;
    }
    if (setting.pillNumberForFromMenstruation == 0 ||
        setting.durationMenstruation == 0) {
      return null;
    }

    final menstruationDateRanges =
        stateValue.calendarScheduledMenstruationBandModels;
    final inTheMiddleDateRanges = menstruationDateRanges
        .map((e) => DateRange(e.begin, e.end))
        .where((element) => element.inRange(today()));

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
    final latestMenstruation = stateValue.latestMenstruation;
    if (latestMenstruation == null) {
      return null;
    }
    if (stateValue.menstruations.length == 1 &&
        latestMenstruation.dateRange.inRange(today())) {
      return null;
    }
    return MenstruationHistoryCardState(
      allMenstruations: stateValue.menstruations,
      latestMenstruation: latestMenstruation,
      isPremium: stateValue.premiumAndTrial.isPremium,
      isTrial: stateValue.premiumAndTrial.isTrial,
      trialDeadlineDate: stateValue.premiumAndTrial.trialDeadlineDate,
    );
  }
}
