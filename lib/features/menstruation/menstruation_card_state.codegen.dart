import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/datetime/day.dart';

part 'menstruation_card_state.codegen.freezed.dart';

@freezed
abstract class MenstruationCardState with _$MenstruationCardState {
  const MenstruationCardState._();
  const factory MenstruationCardState({required String title, required DateTime scheduleDate, required String countdownString}) =
      _MenstruationCardState;

  factory MenstruationCardState.future({required DateTime nextSchedule}) {
    final diff = daysBetween(today(), nextSchedule);
    return MenstruationCardState(title: L.menstruationScheduleDate, scheduleDate: nextSchedule, countdownString: L.menstruationRemainingDay(diff));
  }

  factory MenstruationCardState.inTheMiddle({required DateTime scheduledDate}) {
    final diff = daysBetween(scheduledDate, today());
    return MenstruationCardState(
      title: L.menstruationScheduleDate,
      scheduleDate: scheduledDate,
      countdownString: L.menstruationScheduleDateWithNumber(diff + 1),
    );
  }

  factory MenstruationCardState.record({required Menstruation menstruation}) => MenstruationCardState(
    title: L.menstruationStartDate,
    scheduleDate: menstruation.beginDate,
    countdownString: L.menstruationProgressingDay(daysBetween(menstruation.beginDate, today()) + 1),
  );
}
