import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/features/calendar/date_range.dart';
import 'package:pilll/features/menstruation/history/menstruation_history_card.dart';
import 'package:pilll/features/menstruation/history/menstruation_history_card_state.dart';
import 'package:pilll/features/menstruation/menstruation_card.dart';
import 'package:pilll/features/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationCardList extends StatelessWidget {
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final PremiumAndTrial premiumAndTrial;
  final Setting setting;
  final PillSheetGroup? latestPillSheetGroup;
  final Menstruation? latestMenstruation;
  final List<Menstruation> allMenstruation;

  const MenstruationCardList({
    Key? key,
    required this.calendarScheduledMenstruationBandModels,
    required this.premiumAndTrial,
    required this.setting,
    required this.latestPillSheetGroup,
    required this.latestMenstruation,
    required this.allMenstruation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cardState = cardState(latestPillSheetGroup, latestMenstruation, setting, calendarScheduledMenstruationBandModels);
    final _historyCardState = historyCardState(latestMenstruation, allMenstruation, premiumAndTrial);
    return Expanded(
      child: Container(
        color: PilllColors.background,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          scrollDirection: Axis.vertical,
          children: [
            if (_cardState != null) ...[
              MenstruationCard(_cardState),
              const SizedBox(height: 24),
            ],
            if (_historyCardState != null) MenstruationHistoryCard(state: _historyCardState),
          ],
        ),
      ),
    );
  }
}

MenstruationCardState? cardState(
  PillSheetGroup? pillSheetGroup,
  Menstruation? menstration,
  Setting setting,
  List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels,
) {
  if (menstration != null && menstration.dateRange.inRange(today())) {
    return MenstruationCardState.record(menstruation: menstration);
  }

  if (pillSheetGroup == null || pillSheetGroup.pillSheets.isEmpty) {
    return null;
  }
  if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
    return null;
  }

  final menstruationDateRanges = calendarScheduledMenstruationBandModels;
  final inTheMiddleDateRanges = menstruationDateRanges.map((e) => DateRange(e.begin, e.end)).where((element) => element.inRange(today()));

  if (inTheMiddleDateRanges.isNotEmpty) {
    return MenstruationCardState.inTheMiddle(scheduledDate: inTheMiddleDateRanges.first.begin);
  }

  final futureDateRanges = menstruationDateRanges.where((element) => element.begin.isAfter(today()));
  if (futureDateRanges.isNotEmpty) {
    return MenstruationCardState.future(nextSchedule: futureDateRanges.first.begin);
  }

  assert(false);
  return null;
}

MenstruationHistoryCardState? historyCardState(
  Menstruation? menstruation,
  List<Menstruation> allMenstruation,
  PremiumAndTrial premiumAndTrial,
) {
  if (menstruation == null) {
    return null;
  }
  if (allMenstruation.length == 1 && menstruation.dateRange.inRange(today())) {
    return null;
  }
  return MenstruationHistoryCardState(
    allMenstruations: allMenstruation,
    latestMenstruation: menstruation,
    isPremium: premiumAndTrial.isPremium,
    isTrial: premiumAndTrial.isTrial,
    trialDeadlineDate: premiumAndTrial.trialDeadlineDate,
  );
}
