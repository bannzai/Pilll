import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menstruation_card_state.freezed.dart';

@freezed
abstract class MenstruationCardState implements _$MenstruationCardState {
  MenstruationCardState._();
  factory MenstruationCardState({
    required DateTime scheduleDate,
    required String countdownString,
  }) = _MenstruationCardState;

  factory MenstruationCardState.schedule({
    required DateTime scheduleDate,
    required DateTime today,
  }) =>
      MenstruationCardState(
          scheduleDate: scheduleDate,
          countdownString: "あと${today.difference(scheduleDate).inDays}日");

  factory MenstruationCardState.record({
    required Menstruation menstruation,
    required DateTime today,
  }) =>
      MenstruationCardState(
        scheduleDate: menstruation.beginDate,
        countdownString: menstruation.isPreview
            ? "生理予定${today.difference(menstruation.beginDate).inDays}日目"
            : "${today.difference(menstruation.beginDate).inDays}日目",
      );
}
