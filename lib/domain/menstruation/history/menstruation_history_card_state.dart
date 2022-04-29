import 'dart:math';

import 'package:pilll/domain/menstruation_list/menstruation_list_row.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
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

  bool get moreButtonIsHidden => latestMenstruation.dateRange.inRange(today())
      ? allMenstruations.length <= 3
      : allMenstruations.length <= 2;
  List<MenstruationListRowState> get rows {
    if (allMenstruations.isEmpty) {
      return [];
    }
    var menstruations = dropInTheMiddleMenstruation(allMenstruations);
    if (menstruations.isEmpty) {
      return [];
    }
    final rows = MenstruationListRowState.rows(menstruations);
    final length = min(2, rows.length);
    return rows.sublist(0, length);
  }

  String get avalageMenstruationDuration {
    if (allMenstruations.length <= 1) {
      return "-";
    }
    final rows = MenstruationListRowState.rows(allMenstruations);

    int count = 0;
    int totalMenstruationDuration = 0;
    for (final row in rows) {
      final menstruationDuration = row.menstruationDuration;
      if (menstruationDuration == null) {
        continue;
      }
      count += 1;
      totalMenstruationDuration += menstruationDuration;
    }

    return (totalMenstruationDuration / count).round().toString();
  }

  String get avalageMenstruationPeriod {
    if (allMenstruations.length <= 1) {
      return "-";
    }

    int count = 0;
    int totalMenstruationPeriod = 0;
    for (final menstruation in dropInTheMiddleMenstruation(allMenstruations)) {
      final menstruationPeriod = menstruation.dateRange.days + 1;
      count += 1;
      totalMenstruationPeriod += menstruationPeriod;
    }

    return (totalMenstruationPeriod / count).round().toString();
  }
}
