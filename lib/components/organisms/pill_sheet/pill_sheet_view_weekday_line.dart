import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:flutter/material.dart';

class PillSheetViewWeekdayLine extends StatelessWidget {
  const PillSheetViewWeekdayLine({
    Key? key,
    required this.firstWeekday,
  }) : super(key: key);

  final Weekday? firstWeekday;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: () {
          final firstWeekday = this.firstWeekday;
          if (firstWeekday == null) {
            return <Widget>[];
          }

          return WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday)
              .map(
                (weekday) => Container(
                  width: PillSheetViewLayout.componentWidth,
                  color: Colors.transparent,
                  child: Center(child: WeekdayBadge(weekday: weekday)),
                ),
              )
              .toList();
        }());
  }
}
