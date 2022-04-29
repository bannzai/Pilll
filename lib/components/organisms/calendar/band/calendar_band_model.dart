import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

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
  final Menstruation menstruation;
  CalendarMenstruationBandModel(this.menstruation)
      : super(menstruation.beginDate, menstruation.endDate);
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
