import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
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
                Positioned.fill(
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
              Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${date.day}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _textColor())
                          .merge(FontType.gridElement),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _textColor() {
    if (isToday) {
      return PilllColors.white;
    }
    final onTap = this.onTap;
    if (onTap == null) {
      return weekday.weekdayColor().withAlpha((255 * 0.4).floor());
    }
    return weekday.weekdayColor();
  }

  Widget _number() {
    if (isToday) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: PilllColors.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "${date.day}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PilllColors.white,
            ).merge(FontType.gridElement),
          ),
        ),
      );
    } else {
      return Text(
        "${date.day}",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: onTap == null
              ? weekday.weekdayColor().withAlpha((255 * 0.4).floor())
              : weekday.weekdayColor(),
        ).merge(FontType.gridElement),
      );
    }
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
