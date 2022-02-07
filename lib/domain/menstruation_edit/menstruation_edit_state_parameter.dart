import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/setting.dart';

part 'menstruation_edit_state_parameter.freezed.dart';

@freezed
class MenstruationEditStateParameter with _$MenstruationEditStateParameter {
  const factory MenstruationEditStateParameter({
    required Menstruation? menstruation,
    required Setting? setting,
  }) = _MenstruationEditStateParameter;
}
