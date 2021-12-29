import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

part 'calendar_page_state.freezed.dart';

@freezed
class CalendarPageState with _$CalendarPageState {
  CalendarPageState._();
  factory CalendarPageState({
    @Default(0) int currentCalendarIndex,
    @Default(true) bool isNotYetLoaded,
    @Default([]) List<Menstruation> menstruations,
    Setting? setting,
    PillSheetGroup? latestPillSheetGroup,
    @Default([]) List<Diary> diariesForMonth,
    @Default([]) List<PillSheetModifiedHistory> allPillSheetModifiedHistories,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? trialDeadlineDate,
    Object? exception,
  }) = _CalendarPageState;

  bool get shouldShowIndicator => isNotYetLoaded || setting == null;

  final List<DateTime> calendarDataSource = _calendarDataSource();
  int get todayCalendarIndex => calendarDataSource
      .lastIndexWhere((element) => isSameMonth(element, today()));
  DateTime get displayMonth => calendarDataSource[currentCalendarIndex];
  String get displayMonthString => DateTimeFormatter.yearAndMonth(displayMonth);

  final _satisfyBandCount = 15;
  late final List<CalendarBandModel> allBands = buildBandModels(
    latestPillSheetGroup,
    setting,
    menstruations,
    _satisfyBandCount,
  );
}

List<DateTime> _calendarDataSource() {
  final base = today();
  return List.generate(24, (index) => (index + 1) - 12)
      .map((e) => DateTime(base.year, base.month + e, 1))
      .toList();
}
