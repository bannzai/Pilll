import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';

part 'menstruation_edit.freezed.dart';

@freezed
abstract class MenstruationEditState implements _$MenstruationEditState {
  MenstruationEditState._();
  factory MenstruationEditState({
    required Menstruation? menstruation,
  }) = _MenstruationEditState;

  List<DateTime> dates() {
    final menstruation = this.menstruation;
    if (menstruation != null) {
      return [
        menstruation.beginDate,
        DateTime(
            menstruation.beginDate.year, menstruation.beginDate.month + 1, 1),
      ];
    } else {
      final t = today();
      return [
        t,
        DateTime(t.year, t.month + 1, 1),
      ];
    }
  }
}
