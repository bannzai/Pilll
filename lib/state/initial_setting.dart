import 'package:Pilll/model/initial_setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'initial_setting.freezed.dart';

@freezed
abstract class InitialSettingState implements _$InitialSettingState {
  InitialSettingState._();
  factory InitialSettingState(
          {@Default(InitialSettingModel.empty()) InitialSettingModel entity}) =
      _InitialSettingState;
}
