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
  final bool showsMenstruationMark;
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
          showsMenstruationMark: false,
          date: date,
        );

  const CalendarDayTile({
    Key? key,
    required this.date,
    required this.weekday,
    required this.showsDiaryMark,
    required this.showsScheduleMark,
    required this.showsMenstruationMark,
    required this.onTap,
  }) : super(key: key);

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
                    children: [
                      const Spacer(),
                      if (showsDiaryMark) ...[
                        _diaryMarkWidget(),
                      ],
                      if (showsDiaryMark && showsScheduleMark) ...[
                        const SizedBox(width: 4),
                      ],
                      if (showsScheduleMark) ...[
                        _scheduleMarkWidget(),
                      ],
                      const Spacer(),
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
          if (showsMenstruationMark)
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
    final weekdayColor = () {
      switch (weekday) {
        case Weekday.Sunday:
          return weekday.weekdayColor();
        case Weekday.Monday:
          return TextColor.main;
        case Weekday.Tuesday:
          return TextColor.main;
        case Weekday.Wednesday:
          return TextColor.main;
        case Weekday.Thursday:
          return TextColor.main;
        case Weekday.Friday:
          return TextColor.main;
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
      decoration: BoxDecoration(color: PilllColors.gray, borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _scheduleMarkWidget() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: PilllColors.primary, borderRadius: BorderRadius.circular(4)),
    );
  }

  bool get _isToday => isSameDay(date, today());
}
