import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_page_state.freezed.dart';

@freezed
abstract class SettingState implements _$SettingState {
  SettingState._();
  factory SettingState({
    required Setting? setting,
    PillSheetGroup? latestPillSheetGroup,
    @Default(false) bool userIsUpdatedFrom132,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? trialDeadlineDate,
    Object? exception,
  }) = _SettingState;
}
