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
  final double horizontalPadding;

  final Widget? diaryMark;

  const CalendarDayTile({
    Key? key,
    required this.date,
    required this.weekday,
    required this.isToday,
    required this.horizontalPadding,
    this.diaryMark,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - horizontalPadding * 2) /
          Weekday.values.length,
      height: CalendarConstants.tileHeight,
      child: RawMaterialButton(
        onPressed: () => onTap != null ? onTap!(date) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (diaryMark != null) diaryMark!,
            Container(
              width: 32,
              height: 32,
              decoration: isToday
                  ? BoxDecoration(
                      color: PilllColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Center(
                child: Text(
                  "${date.day}",
                  textAlign: TextAlign.center,
                  style: () {
                    if (isToday) {
                      return TextStyle(color: PilllColors.white)
                          .merge(FontType.gridElement);
                    }
                    return TextStyle(
                            color: onTap == null
                                ? weekday
                                    .weekdayColor()
                                    .withAlpha((255 * 0.4).floor())
                                : weekday.weekdayColor())
                        .merge(FontType.gridElement);
                  }(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
