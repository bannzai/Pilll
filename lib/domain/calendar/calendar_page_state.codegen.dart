import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:riverpod/riverpod.dart';

part 'calendar_page_state.codegen.freezed.dart';

final calendarPageStateProvider =
    Provider<AsyncValue<CalendarPageState>>((ref) {
  final allMenstruations = ref.watch(allMenstruationStreamProvider);
  final setting = ref.watch(settingStreamProvider);
  final diary = ref.watch(diaryStreamProvider);
});

@freezed
class CalendarPageState with _$CalendarPageState {
  CalendarPageState._();
  factory CalendarPageState({
    @Default(0) int currentCalendarIndex,
    Setting? setting,
    PillSheetGroup? latestPillSheetGroup,
    @Default([]) List<PillSheetModifiedHistory> allPillSheetModifiedHistories,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? trialDeadlineDate,
    Object? exception,
  }) = _CalendarPageState;

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
