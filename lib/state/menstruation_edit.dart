import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/util/datetime/date_compare.dart';

part 'menstruation_edit.freezed.dart';

@freezed
abstract class MenstruationEditState implements _$MenstruationEditState {
  MenstruationEditState._();
  factory MenstruationEditState({
    required Menstruation menstruation,
  }) = _MenstruationEditState;

  List<DateTime> dates() {
    return [
      menstruation.beginDate,
      DateTime(menstruation.beginDate.year, menstruation.beginDate.month + 1, 1)
    ];
  }
}
