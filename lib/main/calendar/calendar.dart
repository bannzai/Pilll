import 'package:Pilll/main/calendar/calculator.dart';
import 'package:Pilll/main/calendar/calendar_band_model.dart';
import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final int weekdayCount = 7;
  static final double tileHeight = 60;
}

class Calendar extends StatelessWidget {
  final Calculator calculator;
  final List<CalendarBandModel> bandModels;

  const Calendar({Key key, this.calculator, this.bandModels}) : super(key: key);

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
        ...List.generate(calculator.lineCount(), (_line) {
          var line = _line + 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: [
                  Row(
                    children: Weekday.values.map((weekday) {
                      bool isPreviousMonth =
                          weekday.index < calculator.weekdayOffset() &&
                              line == 1;
                      if (isPreviousMonth) {
                        return CalendarDayTile(
                            disable: true,
                            weekday: weekday,
                            day: calculator
                                .dateTimeForPreviousMonthTile(weekday)
                                .day);
                      }
                      int day = (line - 1) * CalendarConstants.weekdayCount +
                          weekday.index -
                          calculator.weekdayOffset() +
                          1;
                      bool isNextMonth = day > calculator.lastDay();
                      if (isNextMonth) {
                        return Expanded(child: Container());
                      }
                      return CalendarDayTile(
                        weekday: weekday,
                        day: day,
                      );
                    }).toList(),
                  ),
                  ..._bands(context, line)
                ],
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }

  List<Widget> _bands(BuildContext context, int line) {
    var range = calculator.dateRangeOfLine(line);
    return bandModels.map((bandModel) {
      if (range.inRange(bandModel.begin) || range.inRange(bandModel.end)) {
        var length =
            range.union(DateRange(bandModel.begin, bandModel.end)).days;
        var tileWidth =
            MediaQuery.of(context).size.width / Weekday.values.length;
        return Positioned(
          left: 0,
          width: tileWidth * length,
          bottom: 0,
          height: 14,
          child: _band(bandModel),
        );
      }
      return Container();
    }).toList();
  }

  Widget _band(CalendarBandModel model) {
    return Container(
      decoration: BoxDecoration(color: model.color),
      child: Center(
        child: Text(model.label,
            style: FontType.sSmallTitle.merge(TextColorStyle.white)),
      ),
    );
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
