import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

abstract class CalendarBandModel {
  Color get color;
  String get label;

  final DateTime begin;
  final DateTime end;
  CalendarBandModel(this.begin, this.end);
}

class CalendarScheduledMenstruationBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.menstruation;
  @override
  String get label => "";
  CalendarScheduledMenstruationBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}

class CalendarMenstruationBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.red;
  @override
  String get label => "";
  CalendarMenstruationBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}

class CalendarNextPillSheetBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.duration;
  @override
  String get label => "新しいシート開始 ▶︎";
  CalendarNextPillSheetBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}
