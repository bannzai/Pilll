import 'package:pilll/entity/menstruation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

part 'menstruation.freezed.dart';

@freezed
abstract class MenstruationState implements _$MenstruationState {
  MenstruationState._();
  factory MenstruationState({
    required DateTime targetDate,
    @Default([]) List<Menstruation> entities,
  }) = _MenstruationState;

  String get displayMonth => DateTimeFormatter.jaMonth(targetDate);
}
