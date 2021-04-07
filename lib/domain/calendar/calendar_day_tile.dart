import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/entity/weekday.dart';

class CalendarDayTile extends StatelessWidget {
  final DateTime date;
  final Weekday weekday;
  final bool isToday;
  final bool hasDiary;
  final bool isIntoMenstruationDuration;
  final Function(DateTime)? onTap;

  const CalendarDayTile({
    Key? key,
    required this.date,
    required this.weekday,
    required this.isToday,
    required this.hasDiary,
    required this.isIntoMenstruationDuration,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RawMaterialButton(
        onPressed: () => onTap != null ? onTap!(date) : null,
        child: Container(
          height: CalendarConstants.tileHeight,
          child: Stack(
            children: <Widget>[
              if (hasDiary) ...[
                Positioned.fill(
                  top: 8,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: _diaryMarkWidget()),
                )
              ],
              if (isIntoMenstruationDuration)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: PilllColors.menstruation,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              if (isToday)
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: PilllColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              Positioned(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${date.day}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _textColor()).merge(_font()),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _font() {
    if (isIntoMenstruationDuration) {
      return FontType.gridElementBold;
    } else {
      return FontType.gridElement;
    }
  }

  Color _textColor() {
    if (isToday) {
      return PilllColors.white;
    }
    final weekdayColor = () {
      switch (weekday) {
        case Weekday.Sunday:
          return weekday.weekdayColor();
        case Weekday.Monday:
          return PilllColors.black;
        case Weekday.Tuesday:
          return PilllColors.black;
        case Weekday.Wednesday:
          return PilllColors.black;
        case Weekday.Thursday:
          return PilllColors.black;
        case Weekday.Friday:
          return PilllColors.black;
        case Weekday.Saturday:
          return weekday.weekdayColor();
      }
    }();
    final onTap = this.onTap;
    final alpha = (255 * (onTap != null ? 1 : 0.4)).floor();
    return weekdayColor.withAlpha(alpha);
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
