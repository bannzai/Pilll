import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/menstruation/history/menstruation_history_card.dart';
import 'package:pilll/domain/menstruation/history/menstruation_history_card_state.dart';
import 'package:pilll/domain/menstruation/menstruation_card.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.codegen.dart';
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
    final cardState = _cardState();
    final historyCardState = _historyCardState();
    return Expanded(
      child: Container(
        color: PilllColors.background,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          scrollDirection: Axis.vertical,
          children: [
            if (cardState != null) ...[
              MenstruationCard(cardState),
              const SizedBox(height: 24),
            ],
            if (historyCardState != null) MenstruationHistoryCard(state: historyCardState),
          ],
        ),
      ),
    );
  }

  MenstruationCardState? _cardState() {
    final latestMenstruation = this.latestMenstruation;
    if (latestMenstruation != null && latestMenstruation.dateRange.inRange(today())) {
      return MenstruationCardState.record(menstruation: latestMenstruation);
    }

    final latestPillSheetGroup = this.latestPillSheetGroup;
    if (latestPillSheetGroup == null || latestPillSheetGroup.pillSheets.isEmpty) {
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

  MenstruationHistoryCardState? _historyCardState() {
    final latestMenstruation = this.latestMenstruation;
    if (latestMenstruation == null) {
      return null;
    }
    if (allMenstruation.length == 1 && latestMenstruation.dateRange.inRange(today())) {
      return null;
    }
    return MenstruationHistoryCardState(
      allMenstruations: allMenstruation,
      latestMenstruation: latestMenstruation,
      isPremium: premiumAndTrial.isPremium,
      isTrial: premiumAndTrial.isTrial,
      trialDeadlineDate: premiumAndTrial.trialDeadlineDate,
    );
  }
}
