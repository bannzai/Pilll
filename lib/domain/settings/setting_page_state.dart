import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_page_state.freezed.dart';

@freezed
class SettingState with _$SettingState {
  const SettingState._();
  const factory SettingState({
    Setting? setting,
    PillSheetGroup? latestPillSheetGroup,
    @Default(false) bool userIsUpdatedFrom132,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? trialDeadlineDate,
    Object? exception,
  }) = _SettingState;
}
