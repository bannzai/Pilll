import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/initial_setting/pill_sheet.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/setting.dart';

part 'calendar_page.freezed.dart';

@freezed
abstract class CalendarPageState implements _$CalendarPageState {
  CalendarPageState._();
  factory CalendarPageState({
    required List<Menstruation> menstruations,
    Setting? setting,
    PillSheet? latestPillSheet,
  }) = _CalendarPageState;
}
