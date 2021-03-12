import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'initial_setting.freezed.dart';

@freezed
abstract class InitialSettingState implements _$InitialSettingState {
  InitialSettingState._();
  factory InitialSettingState(InitialSettingModel entity) =
      _InitialSettingState;

  DateTime? reminderTimeOrDefault(int index) {
    if (index < entity.reminderTimes.length) {
      return entity.reminderDateTime(index);
    }
    final n = now();
    if (index == 0) {
      return DateTime(n.year, n.month, n.day, 21, 0, 0);
    }
    if (index == 1) {
      return DateTime(n.year, n.month, n.day, 22, 0, 0);
    }
    return null;
  }
}
