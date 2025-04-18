// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

enum Weekday {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

extension WeekdayFunctions on Weekday {
  static Weekday weekdayFromDate(DateTime date) {
    var weekdayIndex = date.weekday;
    var weekdays = Weekday.values;
    var sunday = weekdays.first;
    weekdays = weekdays.sublist(1)
      ..addAll(weekdays.sublist(0, weekdays.length))
      ..insert(0, sunday);
    return weekdays[weekdayIndex];
  }

  static List<Weekday> weekdaysForFirstWeekday(Weekday firstWeekday) {
    return Weekday.values.sublist(firstWeekday.index)..addAll(Weekday.values.sublist(0, firstWeekday.index));
  }

  // TODO: [Localizations]
  String weekdayString() {
    return DateTimeFormatter.shortWeekdays()[index];
  }

  Color weekdayColor() {
    switch (this) {
      case Weekday.Sunday:
        return AppColors.sunday;
      case Weekday.Monday:
        return AppColors.weekday;
      case Weekday.Tuesday:
        return AppColors.weekday;
      case Weekday.Wednesday:
        return AppColors.weekday;
      case Weekday.Thursday:
        return AppColors.weekday;
      case Weekday.Friday:
        return AppColors.weekday;
      case Weekday.Saturday:
        return AppColors.saturday;
    }
  }
}
