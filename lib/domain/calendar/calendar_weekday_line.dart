import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_day_tile.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/diary/post_diary_page.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/calculator.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/domain/diary/confirm_diary_sheet.dart';
import 'package:pilll/util/datetime/day.dart' as utility;

class CalendarWeekdayLine extends StatelessWidget {
  final BuildContext context;
  final int line;
  final List<Diary> diaries;
  final Calculator calculator;
  final List<CalendarBandModel> bandModels;
  final double horizontalPadding;

  const CalendarWeekdayLine({
    Key? key,
    required this.context,
    required this.line,
    required this.diaries,
    required this.calculator,
    required this.bandModels,
    required this.horizontalPadding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: Weekday.values.map((weekday) {
            bool isPreviousMonth =
                weekday.index < calculator.weekdayOffset() && line == 1;
            if (isPreviousMonth) {
              return CalendarDayTile(
                  isToday: false,
                  onTap: null,
                  weekday: weekday,
                  day: calculator
                      .dateTimeForPreviousMonthTile(weekday.index)
                      .day);
            }
            int day = (line - 1) * Weekday.values.length +
                weekday.index -
                calculator.weekdayOffset() +
                1;
            bool isNextMonth = day > calculator.lastDay();
            if (isNextMonth) {
              return Expanded(child: Container());
            }
            bool isExistDiary = diaries
                .where((element) => isSameDay(element.date,
                    DateTime(calculator.date.year, calculator.date.month, day)))
                .isNotEmpty;
            final targetMonth = calculator.date;
            return CalendarDayTile(
              isToday: isSameDay(utility.today(),
                  DateTime(targetMonth.year, targetMonth.month, day)),
              weekday: weekday,
              day: day,
              upperWidget: isExistDiary ? _diaryMarkWidget() : null,
              onTap: () {
                final date = calculator
                    .dateTimeForFirstDayOfMonth()
                    .add(Duration(days: day - 1));
                if (date.isAfter(utility.today())) {
                  return;
                }
                if (!isExistDiary) {
                  Navigator.of(context).push(PostDiaryPageRoute.route(date));
                } else {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ConfirmDiarySheet(date),
                    backgroundColor: Colors.transparent,
                  );
                }
              },
            );
          }).toList(),
        ),
        ...bands(context, bandModels, calculator, horizontalPadding, line)
      ],
    );
  }

  Widget _diaryMarkWidget() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          color: PilllColors.gray, borderRadius: BorderRadius.circular(4)),
    );
  }
}
