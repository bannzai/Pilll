import 'package:pilll/entity/setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.freezed.dart';

@freezed
abstract class SettingState implements _$SettingState {
  SettingState._();
  factory SettingState(
      {required Setting? entity,
      @Default(false) required bool userIsUpdatedFrom132}) = _SettingState;
}
