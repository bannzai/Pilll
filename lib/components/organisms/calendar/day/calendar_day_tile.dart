import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_record.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/features/calendar/components/const.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

class CalendarDayTile extends StatelessWidget {
  final DateTime date;
  final Weekday weekday;
  final Diary? diary;
  final Schedule? schedule;
  final Function(DateTime)? onTap;

  const CalendarDayTile.grayout({
    Key? key,
    required DateTime date,
    required Weekday weekday,
  }) : this(
          key: key,
          onTap: null,
          weekday: weekday,
          diary: null,
          schedule: null,
          date: date,
        );

  const CalendarDayTile({
    super.key,
    required this.date,
    required this.weekday,
    required this.diary,
    required this.schedule,
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
          child: Column(
            children: <Widget>[
              _content(),
              CalendarDayRecord(diary: diary, schedule: schedule),
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
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                textAlign: TextAlign.center,
                style: TextStyle(color: _textColor()).merge(_font()),
              ),
            ),
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
      return AppColors.white;
    }
    final weekdayColor = switch (weekday) {
      Weekday.Sunday => weekday.weekdayColor(),
      Weekday.Monday => TextColor.main,
      Weekday.Tuesday => TextColor.main,
      Weekday.Wednesday => TextColor.main,
      Weekday.Thursday => TextColor.main,
      Weekday.Friday => TextColor.main,
      Weekday.Saturday => weekday.weekdayColor(),
    };
    final onTap = this.onTap;
    final alpha = (255 * (onTap != null ? 1 : 0.4)).floor();
    return weekdayColor.withAlpha(alpha);
  }

  bool get _isToday => isSameDay(date, today());
}
