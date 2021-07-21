import 'dart:math';

import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationHistoryCardState {
  final List<Menstruation> _allMenstruations;
  final Menstruation _latestMenstruation;

  MenstruationHistoryCardState(
    this._allMenstruations,
    this._latestMenstruation,
  );

  bool get _latestPillSheetIntoToday =>
      _latestMenstruation.dateRange.inRange(today());

  bool get moreButtonIsHidden => _latestPillSheetIntoToday
      ? _allMenstruations.length <= 3
      : _allMenstruations.length <= 2;
  List<MenstruationHistoryRowState> get rows {
    if (_allMenstruations.isEmpty) {
      return [];
    }
    var menstruations = dropLatestMenstruationIfNeeded(_allMenstruations);
    if (menstruations.isEmpty) {
      return [];
    }
    final rows = MenstruationHistoryRowState.rows(menstruations);
    final length = min(2, rows.length);
    return rows.sublist(0, length);
  }
}
