import 'package:pilll/entity/menstruation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/util/datetime/day.dart' as util;
import 'package:pilll/util/formatter/date_time_formatter.dart';

part 'menstruation.freezed.dart';

@freezed
abstract class MenstruationState implements _$MenstruationState {
  MenstruationState._();
  factory MenstruationState({
    required int displayMonthOffset,
    @Default([]) List<Menstruation> entities,
  }) = _MenstruationState;
  String get displayMonth {
    final today = util.today();
    return DateTimeFormatter.jaMonth(
        DateTime(today.year, today.month + displayMonthOffset, today.day));
  }
}
