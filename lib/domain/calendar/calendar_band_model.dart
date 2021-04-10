import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/calendar_band.dart';

abstract class CalendarBandModel {
  Color get color;
  String get label;
  double get bottom;
  bool get isNecessaryBorder;

  final DateTime begin;
  final DateTime end;
  CalendarBandModel(this.begin, this.end);
}

class CalendarScheduledMenstruationBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.menstruation;
  @override
  String get label => "";
  @override
  double get bottom => 0;
  @override
  bool get isNecessaryBorder => true;

  CalendarScheduledMenstruationBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}

class CalendarMenstruationBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.menstruation.withAlpha(153);
  @override
  String get label => "";
  @override
  double get bottom => 0;
  @override
  bool get isNecessaryBorder => false;
  CalendarMenstruationBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}

class CalendarNextPillSheetBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.duration;
  @override
  String get label => "新しいシート開始 ▶︎";
  @override
  double get bottom => CalendarBandConst.height;
  @override
  bool get isNecessaryBorder => false;
  CalendarNextPillSheetBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}
