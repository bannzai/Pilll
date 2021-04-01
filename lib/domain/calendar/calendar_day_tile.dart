import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/entity/weekday.dart';

class CalendarDayTile extends StatelessWidget {
  final int day;
  final bool isToday;
  final Weekday weekday;
  final VoidCallback? onTap;

  final Widget? upperWidget;
  final Widget? lowerWidget;

  const CalendarDayTile({
    Key? key,
    required this.day,
    required this.weekday,
    required this.isToday,
    this.upperWidget,
    this.lowerWidget,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RawMaterialButton(
        onPressed: onTap,
        child: Container(
          height: CalendarConstants.tileHeight,
          child: Stack(
            children: <Widget>[
              if (upperWidget != null) ...[
                Positioned.fill(
                  top: 8,
                  child:
                      Align(alignment: Alignment.topCenter, child: upperWidget),
                )
              ],
              if (!isToday)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$day",
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
                          "$day",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PilllColors.white,
                          ).merge(FontType.gridElement),
                        ),
                      ),
                    ),
                  ),
                ),
              if (lowerWidget != null) ...[
                Positioned.fill(
                  top: 8,
                  child:
                      Align(alignment: Alignment.topCenter, child: lowerWidget),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
