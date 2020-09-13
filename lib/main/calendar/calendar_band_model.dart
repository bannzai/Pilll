import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';

abstract class CalendarBandModel {
  Color get color;
  String get label;

  final DateTime start;
  final DateTime end;
  CalendarBandModel(this.start, this.end);
}

class CalendarMenstruationBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.menstruation;
  @override
  String get label => "";
  CalendarMenstruationBandModel(DateTime start, DateTime end)
      : super(start, end);
}

class CalendarNextPillSheetBandModel extends CalendarBandModel {
  @override
  Color get color => PilllColors.duration;
  @override
  String get label => "新しいシート開始 ▶︎";
  CalendarNextPillSheetBandModel(DateTime start, DateTime end)
      : super(start, end);
}
