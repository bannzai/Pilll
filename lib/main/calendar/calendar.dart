import 'package:Pilll/main/calendar/calendar_band_model.dart';
import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final int weekdayCount = 7;
  static final double tileHeight = 60;
}

class Calendar extends StatelessWidget {
  final List<CalendarBandModel> lineModels;
  final DateTime date;
  const Calendar({Key key, this.date, this.lineModels}) : super(key: key);

  DateTime _dateTimeForFirstDayofMonth() {
    return DateTime(date.year, date.month, 1);
  }

  int _lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_dateTimeForFirstDayofMonth()).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int _lineCount() => (_tileCount() / 7).ceil();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              CalendarConstants.weekdayCount,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        Divider(height: 1),
        ...List.generate(_lineCount(), (line) {
          return Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: Weekday.values.map((weekday) {
                      bool isPreviousMonth =
                          weekday.index < _weekdayOffset() && line == 0;
                      if (isPreviousMonth) {
                        return CalendarDayTile(
                            disable: true,
                            weekday: weekday,
                            day: _dateTimeForPreviousMonthTile(weekday).day);
                      }
                      int day = line * CalendarConstants.weekdayCount +
                          weekday.index -
                          _weekdayOffset() +
                          1;
                      bool isNextMonth = day > _lastDay();
                      if (isNextMonth) {
                        return Expanded(child: Container());
                      }
                      return CalendarDayTile(
                        disable: false,
                        weekday: weekday,
                        day: day,
                        lowerWidget:
                            _band(CalendarNextPillSheetBandModel(null, null)),
                      );
                    }).toList(),
                  ),
                  Divider(height: 1),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _band(CalendarBandModel model) {
    return Container(
      width: 200,
      height: 12,
      decoration: BoxDecoration(color: model.color),
      child: Center(
        child: Text(
          model.label,
          style: FontType.smallTitle.merge(TextColorStyle.white),
        ),
      ),
    );
  }

  DateTime _dateTimeForPreviousMonthTile(Weekday weekday) {
    var dateTimeForLastDayOfPreviousMonth = DateTime(date.year, date.month, 0);
    var offset =
        WeekdayFunctions.weekdayFromDate(dateTimeForLastDayOfPreviousMonth)
            .index;
    return DateTime(
        dateTimeForLastDayOfPreviousMonth.year,
        dateTimeForLastDayOfPreviousMonth.month,
        dateTimeForLastDayOfPreviousMonth.day - offset + weekday.index);
  }
}

class CalendarDayTile extends StatelessWidget {
  final int day;
  final Weekday weekday;
  final bool disable;

  final Widget upperWidget;
  final Widget lowerWidget;

  const CalendarDayTile(
      {Key key,
      this.day,
      this.weekday,
      this.upperWidget,
      this.lowerWidget,
      this.disable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: CalendarConstants.tileHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            upperWidget ?? Spacer(),
            Spacer(),
            Text(
              "$day",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: disable
                    ? WeekdayFunctions.weekdayColor(weekday)
                        .withAlpha((255 * 0.4).floor())
                    : WeekdayFunctions.weekdayColor(weekday),
              ).merge(FontType.calendarDay),
            ),
            Spacer(),
            lowerWidget ?? Spacer(),
          ],
        ),
      ),
    );
  }
}
