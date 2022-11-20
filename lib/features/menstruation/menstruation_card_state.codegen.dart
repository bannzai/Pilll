import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/util/datetime/day.dart';

part '../../features/menstruation/menstruation_card_state.codegen.freezed.dart';

@freezed
class MenstruationCardState with _$MenstruationCardState {
  const MenstruationCardState._();
  const factory MenstruationCardState({
    required String title,
    required DateTime scheduleDate,
    required String countdownString,
  }) = _MenstruationCardState;

  factory MenstruationCardState.future({
    required DateTime nextSchedule,
  }) {
    final diff = daysBetween(today(), nextSchedule);
    return MenstruationCardState(
      title: "生理予定日",
      scheduleDate: nextSchedule,
      countdownString: "あと$diff日",
    );
  }

  factory MenstruationCardState.inTheMiddle({
    required DateTime scheduledDate,
  }) {
    final diff = daysBetween(scheduledDate, today());
    return MenstruationCardState(
      title: "生理予定日",
      scheduleDate: scheduledDate,
      countdownString: "生理予定：${diff + 1}日目",
    );
  }

  factory MenstruationCardState.record({
    required Menstruation menstruation,
  }) =>
      MenstruationCardState(
        title: "生理開始日",
        scheduleDate: menstruation.beginDate,
        countdownString: "${daysBetween(menstruation.beginDate, today()) + 1}日目",
      );
}
