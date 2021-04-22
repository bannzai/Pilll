import 'dart:math';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class MenstruationHistoryRowState {
  final Menstruation menstruation;
  int? menstruationDuration;

  MenstruationHistoryRowState(this.menstruation);

  static int diff(
      MenstruationHistoryRowState lhs, MenstruationHistoryRowState rhs) {
    final range =
        DateRange(lhs.menstruation.beginDate, rhs.menstruation.beginDate);
    return range.days - 1;
  }
}

class MenstruationHistoryRow extends StatelessWidget {
  final MenstruationHistoryRowState state;

  const MenstruationHistoryRow({Key? key, required this.state})
      : super(key: key);

  String get _menstruationDurationString =>
      state.menstruationDuration == null ? "-" : "$state.menstruationDuration";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(DateTimeFormatter.monthAndDay(state.menstruation.beginDate)),
            Text(" - "),
            Text(DateTimeFormatter.monthAndDay(state.menstruation.endDate)),
          ],
        ),
        Row(
          children: List.generate(
            min(9, state.menstruation.dateRange.days),
            (index) {
              return _circle();
            },
          ),
        ),
        Text(_menstruationDurationString),
      ],
    );
  }

  Widget _circle() {
    return Container(
      width: 12,
      height: 12,
      color: PilllColors.menstruation,
    );
  }
}
