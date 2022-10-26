import 'package:collection/collection.dart';
import 'dart:math';

import 'package:pilll/entity/menstruation.codegen.dart';
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

  bool get moreButtonIsHidden =>
      allMenstruations.firstWhereOrNull((element) => element.isActive) != null ? allMenstruations.length <= 3 : allMenstruations.length <= 2;
  Menstruation? get activeMenstruation {
    if (latestMenstruation.isActive) {
      return latestMenstruation;
    }
    return null;
  }

  Menstruation? get previousMenstruation {
    final filtered = allMenstruations.where((element) => !element.isActive);
    if (filtered.isEmpty) {
      return null;
    }
    return filtered.first;
  }

  Menstruation? get secondPreviousMenstruation {
    final filtered = allMenstruations.where((element) => !element.isActive);
    if (filtered.length <= 1) {
      return null;
    }
    return filtered.toList()[1];
  }

  Menstruation? get thirdPreviousMenstruation {
    final filtered = allMenstruations.where((element) => !element.isActive);
    if (filtered.length <= 2) {
      return null;
    }
    return filtered.toList()[2];
  }

  String get avalageMenstruationDuration {
    if (allMenstruations.length <= 1) {
      return "-";
    }

    int totalMenstruationDuration = 0;
    for (var i = 0; i < allMenstruations.length; i++) {
      if (i <= allMenstruations.length - 1) {
        break;
      }
      final menstruation = allMenstruations[i];
      final menstruationDuration = menstruationsDiff(menstruation, allMenstruations[i + 1]);
      if (menstruationDuration != null) {
        totalMenstruationDuration += menstruationDuration;
      }
    }
    return (totalMenstruationDuration / allMenstruations.length).round().toString();
  }

  String get avalageMenstruationPeriod {
    if (allMenstruations.length <= 1) {
      return "-";
    }

    int totalMenstruationPeriod = 0;
    for (final menstruation in allMenstruations) {
      final menstruationPeriod = menstruation.dateRange.days + 1;
      totalMenstruationPeriod += menstruationPeriod;
    }

    return (totalMenstruationPeriod / allMenstruations.length).round().toString();
  }
}
