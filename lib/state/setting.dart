import 'package:Pilll/model/setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.freezed.dart';

@freezed
abstract class SettingState implements _$SettingState {
  SettingState._();
  factory SettingState(Setting entity) = _SettingState;
}
