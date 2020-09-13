import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';

abstract class CalendarLineModel {
  Color get color;
  String get label;

  final DateTime start;
  final DateTime end;
  CalendarLineModel(this.start, this.end);
}

class CalendarMenstruationLineModel extends CalendarLineModel {
  @override
  Color get color => PilllColors.menstruation;
  @override
  String get label => "";
  CalendarMenstruationLineModel(DateTime start, DateTime end)
      : super(start, end);
}

class CalendarNextPillSheetLineModel extends CalendarLineModel {
  @override
  Color get color => PilllColors.duration;
  @override
  String get label => "新しいシート開始 ▶︎";
  CalendarNextPillSheetLineModel(DateTime start, DateTime end)
      : super(start, end);
}
