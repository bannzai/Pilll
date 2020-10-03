import 'package:Pilll/main/calendar/calculator.dart';
import 'package:Pilll/main/calendar/calendar_band_model.dart';
import 'package:Pilll/main/calendar/date_range.dart';
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
  final Calculator calculator;
  final List<CalendarBandModel> bandModels;

  const Calendar(
      {Key key, @required this.calculator, @required this.bandModels})
      : super(key: key);

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
                                .dateTimeForPreviousMonthTile(weekday.index)
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
    return bandModels
        .map((bandModel) {
          if (range.inRange(bandModel.begin) || range.inRange(bandModel.end)) {
            bool isLineBreaked =
                calculator.notInRangeAtLine(line, bandModel.begin);
            int start =
                calculator.offsetForStartPositionAtLine(line, bandModel.begin);

            var length =
                range.union(DateRange(bandModel.begin, bandModel.end)).days + 1;
            var tileWidth = (MediaQuery.of(context).size.width - 32) /
                Weekday.values.length;
            return Positioned(
              left: start.toDouble() * tileWidth,
              width: tileWidth * length,
              bottom: 0,
              height: 15,
              child:
                  CalendarBand(model: bandModel, isLineBreaked: isLineBreaked),
            );
          }
          return null;
        })
        .where((element) => element != null)
        .toList();
  }
}

class CalendarBand extends StatelessWidget {
  const CalendarBand({
    Key key,
    @required this.model,
    @required this.isLineBreaked,
  }) : super(key: key);

  final CalendarBandModel model;
  final bool isLineBreaked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: model.color),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Text(isLineBreaked ? "" : model.label,
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
      @required this.day,
      @required this.weekday,
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
                    ? weekday.weekdayColor().withAlpha((255 * 0.4).floor())
                    : weekday.weekdayColor(),
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
