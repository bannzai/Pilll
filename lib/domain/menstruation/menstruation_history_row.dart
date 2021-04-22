import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class MenstruationHistoryRowState {
  final Menstruation menstruation;
  final String? prefix;
  int? menstruationDuration;

  MenstruationHistoryRowState(this.menstruation, this.prefix);

  static int diff(
      MenstruationHistoryRowState lhs, MenstruationHistoryRowState rhs) {
    final range =
        DateRange(lhs.menstruation.beginDate, rhs.menstruation.beginDate);
    return range.days.abs() - 1;
  }

  String get dateRange {
    return "(${DateTimeFormatter.monthAndDay(menstruation.beginDate)} - ${DateTimeFormatter.monthAndDay(menstruation.endDate)})";
  }

  String get duration {
    final menstruationDuration = this.menstruationDuration;
    if (menstruationDuration == null) {
      return "-";
    }
    return "$menstruationDuration周期";
  }

  double get width {
    final double widthForDay = 10;
    final menstruationDuration = this.menstruationDuration;
    if (menstruationDuration == null) {
      return widthForDay * 28;
    }
    return widthForDay * menstruationDuration;
  }
}

class MenstruationHistoryRow extends StatelessWidget {
  final MenstruationHistoryRowState state;

  const MenstruationHistoryRow({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (state.prefix != null) Text(state.prefix ?? ""),
            Text(state.dateRange),
          ],
        ),
        Container(
          width: state.width,
          decoration: BoxDecoration(
            color: PilllColors.tinBackground,
            borderRadius: BorderRadius.circular(26),
          ),
          height: 20,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                ...List.generate(
                  state.menstruation.dateRange.days,
                  (index) {
                    return [_circle(), SizedBox(width: 4)];
                  },
                ).expand((element) => element).toList(),
                Spacer(),
                Text(
                  state.duration,
                  textAlign: TextAlign.end,
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _circle() {
    return Container(
      decoration: BoxDecoration(
        color: PilllColors.menstruation,
        borderRadius: BorderRadius.circular(6),
      ),
      width: 12,
      height: 12,
    );
  }
}
