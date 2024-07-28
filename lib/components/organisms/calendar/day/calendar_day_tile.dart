import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

class CalendarDayTile extends StatelessWidget {
  final DateTime date;
  final Weekday weekday;
  final bool showsDiaryMark;
  final bool showsScheduleMark;
  final Function(DateTime)? onTap;

  const CalendarDayTile.grayout({
    Key? key,
    required DateTime date,
    required Weekday weekday,
  }) : this(
          key: key,
          onTap: null,
          weekday: weekday,
          showsDiaryMark: false,
          showsScheduleMark: false,
          date: date,
        );

  const CalendarDayTile({
    super.key,
    required this.date,
    required this.weekday,
    required this.showsDiaryMark,
    required this.showsScheduleMark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onTap = this.onTap;
    return Expanded(
      child: RawMaterialButton(
        onPressed: () => onTap != null ? onTap(date) : null,
        child: SizedBox(
          height: CalendarConstants.tileHeight,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                top: 8,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showsDiaryMark) ...[
                        _diaryMarkWidget(),
                      ],
                      if (showsScheduleMark) ...[
                        _scheduleMarkWidget(),
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.center,
                  child: _content(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          if (_isToday)
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: PilllColors.primary,
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
    );
  }

  TextStyle _font() {
    return const TextStyle(
      fontFamily: FontFamily.number,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
  }

  Color _textColor() {
    if (_isToday) {
      return PilllColors.white;
    }
    final weekdayColor = switch (weekday) {
      Weekday.Sunday => weekday.weekdayColor(),
      Weekday.Monday => TextColor.main,
      Weekday.Tuesday => TextColor.main,
      Weekday.Wednesday => TextColor.main,
      Weekday.Thursday => TextColor.main,
      Weekday.Friday => TextColor.main,
      Weekday.Saturday => weekday.weekdayColor()
    };
    final onTap = this.onTap;
    final alpha = (255 * (onTap != null ? 1 : 0.4)).floor();
    return weekdayColor.withAlpha(alpha);
  }

  Widget _diaryMarkWidget() {
    return const Icon(Icons.edit_calendar, color: PilllColors.gray, size: 12);
  }

  Widget _scheduleMarkWidget() {
    return const Icon(Icons.schedule, color: PilllColors.primary, size: 12);
  }

  bool get _isToday => isSameDay(date, today());
}
