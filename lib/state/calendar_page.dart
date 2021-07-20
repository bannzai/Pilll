import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

part 'calendar_page.freezed.dart';

@freezed
abstract class CalendarPageState
    implements _$CalendarPageState, MonthlyCalendarState {
  CalendarPageState._();
  factory CalendarPageState({
    required List<Menstruation> menstruations,
    @Default(0) int currentCalendarIndex,
    Setting? setting,
    PillSheet? latestPillSheet,
    @Default([]) List<Diary> diariesForMonth,
    @Default(true) bool isNotYetLoaded,
  }) = _CalendarPageState;

  bool get shouldShowIndicator => isNotYetLoaded || setting == null;

  final List<DateTime> calendarDataSource = _calendarDataSource();
  int get todayCalendarIndex => calendarDataSource
      .lastIndexWhere((element) => isSameMonth(element, today()));
  String get displayMonth =>
      DateTimeFormatter.yearAndMonth(calendarDataSource[currentCalendarIndex]);

  final _satisfyBandCount = 15;
  late final List<CalendarBandModel> allBands = buildBandModels(
      latestPillSheet, setting, menstruations, _satisfyBandCount);
}

List<DateTime> _calendarDataSource() {
  final base = today();
  return List.generate(24, (index) => (index + 1) - 12)
      .map((e) => DateTime(base.year, base.month + e, 1))
      .toList();
}
