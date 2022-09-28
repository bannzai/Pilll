import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/schedule.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/menstruation/menstruation_calendar_page_index_state_notifier.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

part 'menstruation_state.codegen.freezed.dart';

final todayCalendarPageIndex =
    menstruationWeekCalendarDataSource.lastIndexWhere((element) => element.where((element) => isSameDay(element, today())).isNotEmpty);

final menstruationPageStateProvider = Provider<AsyncValue<MenstruationState>>((ref) {
  final latestPillSheetGroup = ref.watch(latestPillSheetGroupStreamProvider);
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);
  final setting = ref.watch(settingStreamProvider);
  final diaries = ref.watch(diariesStreamAround90Days(today()));
  final menstruations = ref.watch(allMenstruationStreamProvider);
  final schedules = ref.watch(schedulesAround90Days(today()));

  final calendarMenstruationBandModels = ref.watch(calendarMenstruationBandListProvider);
  final calendarScheduledMenstruationBandModels = ref.watch(calendarScheduledMenstruationBandListProvider);
  final calendarNextPillSheetBandModels = ref.watch(calendarNextPillSheetBandListProvider);

  final currentCalendarPageIndex = ref.watch(menstruationCalendarPageIndexStateNotifierProvider);

  if (latestPillSheetGroup is AsyncLoading ||
      premiumAndTrial is AsyncLoading ||
      setting is AsyncLoading ||
      diaries is AsyncLoading ||
      menstruations is AsyncLoading ||
      schedules is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(
      MenstruationState(
        currentCalendarPageIndex: currentCalendarPageIndex,
        todayCalendarPageIndex: todayCalendarPageIndex,
        diariesForAround90Days: diaries.value!,
        schedulesForAround90Days: schedules.value!,
        menstruations: menstruations.value!,
        premiumAndTrial: premiumAndTrial.value!,
        setting: setting.value!,
        latestPillSheetGroup: latestPillSheetGroup.value,
        calendarMenstruationBandModels: calendarMenstruationBandModels.value!,
        calendarScheduledMenstruationBandModels: calendarScheduledMenstruationBandModels.value!,
        calendarNextPillSheetBandModels: calendarNextPillSheetBandModels.value!,
      ),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace: stackTrace);
  }
});

@freezed
class MenstruationState with _$MenstruationState {
  MenstruationState._();
  factory MenstruationState({
    required int currentCalendarPageIndex,
    required int todayCalendarPageIndex,
    required List<Diary> diariesForAround90Days,
    required List<Schedule> schedulesForAround90Days,
    required List<Menstruation> menstruations,
    required PremiumAndTrial premiumAndTrial,
    required Setting setting,
    required PillSheetGroup? latestPillSheetGroup,
    required List<CalendarMenstruationBandModel> calendarMenstruationBandModels,
    required List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels,
    required List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels,
  }) = _MenstruationState;

  DateTime _targetEndDayOfWeekday() {
    final diff = currentCalendarPageIndex - todayCalendarPageIndex;
    final base = today().add(Duration(days: diff * Weekday.values.length));
    return endDayOfWeekday(base);
  }

  String get displayMonth => DateTimeFormatter.jaMonth(_targetEndDayOfWeekday());
  String get buttonString {
    final latestMenstruation = this.latestMenstruation;
    if (latestMenstruation == null) {
      return "生理を記録";
    }
    if (latestMenstruation.dateRange.inRange(today())) {
      return "生理期間を編集";
    }
    return "生理を記録";
  }

  Menstruation? get latestMenstruation {
    return menstruations.isEmpty ? null : menstruations.first;
  }
}

final List<List<DateTime>> menstruationWeekCalendarDataSource = () {
  final base = today();

  var begin = base.subtract(const Duration(days: 90));
  final beginWeekdayOffset = WeekdayFunctions.weekdayFromDate(begin).index;
  begin = begin.subtract(Duration(days: beginWeekdayOffset));

  var end = base.add(const Duration(days: 90));
  final endWeekdayOffset = Weekday.values.last.index - WeekdayFunctions.weekdayFromDate(end).index;
  end = end.add(Duration(days: endWeekdayOffset));

  var diffDay = daysBetween(begin, end);
  diffDay += Weekday.values.length - diffDay % Weekday.values.length;
  List<DateTime> days = [];
  for (int i = 0; i < diffDay; i++) {
    days.add(begin.add(Duration(days: i)));
  }
  return List.generate(
      ((diffDay) / Weekday.values.length).round(), (i) => days.sublist(i * Weekday.values.length, i * Weekday.values.length + Weekday.values.length));
}();
