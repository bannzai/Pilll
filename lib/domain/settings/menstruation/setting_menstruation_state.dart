import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_menstruation_state.freezed.dart';

@freezed
abstract class SettingMenstruationState implements _$SettingMenstruationState {
  SettingMenstruationState._();
  factory SettingMenstruationState({
    @Default(0) currentPageIndex,
  }) = _SettingMenstruationState;
}
