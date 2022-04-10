import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_page_state.codegen.freezed.dart';

@freezed
class SettingState with _$SettingState {
  const SettingState._();
  const factory SettingState({
    Setting? setting,
    PillSheetGroup? latestPillSheetGroup,
    @Default(false) bool userIsUpdatedFrom132,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    @Default(false) bool isHealthDataAvailable,
    DateTime? trialDeadlineDate,
    Object? exception,
  }) = _SettingState;
}
