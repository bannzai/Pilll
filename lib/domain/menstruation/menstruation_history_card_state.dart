import 'dart:math';

import 'package:pilll/domain/menstruation_list/menstruation_list_row.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationHistoryCardState {
  final List<Menstruation> allMenstruations;
  final Menstruation latestMenstruation;
  final bool isPremium;
  final bool isTrial;
  final DateTime? trialDeadlineDate;

  MenstruationHistoryCardState({
    required this.allMenstruations,
    required this.latestMenstruation,
    required this.isPremium,
    required this.isTrial,
    required this.trialDeadlineDate,
  });

  bool get _latestPillSheetIntoToday =>
      latestMenstruation.dateRange.inRange(today());

  bool get moreButtonIsHidden => _latestPillSheetIntoToday
      ? allMenstruations.length <= 3
      : allMenstruations.length <= 2;
  List<MenstruationListRowState> get rows {
    if (allMenstruations.isEmpty) {
      return [];
    }
    var menstruations = dropLatestMenstruationIfNeeded(allMenstruations);
    if (menstruations.isEmpty) {
      return [];
    }
    final rows = MenstruationListRowState.rows(menstruations);
    final length = min(2, rows.length);
    return rows.sublist(0, length);
  }
}
