import 'package:pilll/entity/menstruation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/util/datetime/day.dart';

part 'menstruation_card_state.freezed.dart';

@freezed
abstract class MenstruationCardState implements _$MenstruationCardState {
  MenstruationCardState._();
  factory MenstruationCardState({
    required String title,
    required DateTime scheduleDate,
    required String countdownString,
  }) = _MenstruationCardState;

  factory MenstruationCardState.future({
    required DateTime nextSchedule,
  }) {
    final diff = nextSchedule.difference(today()).inDays;
    return MenstruationCardState(
      title: "生理予定日",
      scheduleDate: nextSchedule,
      countdownString: "あと$diff日",
    );
  }

  factory MenstruationCardState.inTheMiddle({
    required DateTime scheduledDate,
  }) {
    final diff = today().difference(scheduledDate).inDays;
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
        countdownString:
            "${today().difference(menstruation.beginDate).inDays + 1}日目",
      );
}
