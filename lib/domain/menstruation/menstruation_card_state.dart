import 'package:pilll/entity/menstruation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menstruation_card_state.freezed.dart';

@freezed
abstract class MenstruationCardState implements _$MenstruationCardState {
  MenstruationCardState._();
  factory MenstruationCardState({
    required String title,
    required DateTime scheduleDate,
    required String countdownString,
  }) = _MenstruationCardState;

  factory MenstruationCardState.schedule({
    required DateTime scheduleDate,
    required DateTime today,
  }) =>
      MenstruationCardState(
          title: "生理予定日",
          scheduleDate: scheduleDate,
          countdownString: "あと${today.difference(scheduleDate).inDays}日");

  factory MenstruationCardState.record({
    required Menstruation menstruation,
    required DateTime today,
  }) =>
      MenstruationCardState(
        title: "生理開始日",
        scheduleDate: menstruation.beginDate,
        countdownString: menstruation.isNotYetUserEdited
            ? "生理予定${today.difference(menstruation.beginDate).inDays}日目"
            : "${today.difference(menstruation.beginDate).inDays}日目",
      );
}
