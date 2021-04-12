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

  factory MenstruationCardState.schedule({
    required DateTime scheduleDate,
  }) =>
      MenstruationCardState(
          title: "生理予定日",
          scheduleDate: scheduleDate,
          countdownString: () {
            final diff = scheduleDate.difference(today()).inDays;
            if (diff <= 0) {
              return "生理予定：${diff.abs() + 1}日目";
            }
            return "あと${scheduleDate.difference(today()).inDays}日";
          }());

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
