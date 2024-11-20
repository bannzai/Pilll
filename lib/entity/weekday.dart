// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/root/localization/l.dart';  // Lクラスをインポート

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
        return L.sunday;
      case Weekday.Monday:
        return L.monday;
      case Weekday.Tuesday:
        return L.tuesday;
      case Weekday.Wednesday:
        return L.wednesday;
      case Weekday.Thursday:
        return L.thursday;
      case Weekday.Friday:
        return L.friday;
      case Weekday.Saturday:
        return L.saturday;
      default:
        throw ArgumentError.notNull('');
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
        throw ArgumentError.notNull('');
    }
  }
}
