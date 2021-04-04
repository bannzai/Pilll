import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/entity/weekday.dart';

class CalendarDayTile extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final Weekday weekday;
  final Function(DateTime)? onTap;

  final Widget? diaryMark;

  const CalendarDayTile({
    Key? key,
    required this.date,
    required this.weekday,
    required this.isToday,
    this.diaryMark,
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
              if (diaryMark != null) ...[
                Positioned.fill(
                  top: 8,
                  child:
                      Align(alignment: Alignment.topCenter, child: diaryMark),
                )
              ],
              if (!isToday)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${date.day}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: onTap == null
                            ? weekday
                                .weekdayColor()
                                .withAlpha((255 * 0.4).floor())
                            : weekday.weekdayColor(),
                      ).merge(FontType.gridElement),
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
                      child: Center(
                        child: Text(
                          "${date.day}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PilllColors.white,
                          ).merge(FontType.gridElement),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
