// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/color.dart';

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
    return Weekday.values.sublist(firstWeekday.index)
      ..addAll(Weekday.values.sublist(0, firstWeekday.index));
  }

  String weekdayString() {
    switch (this) {
      case Weekday.Sunday:
        return "日";
      case Weekday.Monday:
        return "月";
      case Weekday.Tuesday:
        return "火";
      case Weekday.Wednesday:
        return "水";
      case Weekday.Thursday:
        return "木";
      case Weekday.Friday:
        return "金";
      case Weekday.Saturday:
        return "土";
      default:
        throw ArgumentError.notNull("");
    }
  }

  Color weekdayColor() {
    switch (this) {
      case Weekday.Sunday:
        return PilllColors.sunday;
      case Weekday.Monday:
        return PilllColors.weekday;
      case Weekday.Tuesday:
        return PilllColors.weekday;
      case Weekday.Wednesday:
        return PilllColors.weekday;
      case Weekday.Thursday:
        return PilllColors.weekday;
      case Weekday.Friday:
        return PilllColors.weekday;
      case Weekday.Saturday:
        return PilllColors.saturday;
      default:
        throw ArgumentError.notNull("");
    }
  }
}
