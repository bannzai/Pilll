import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'setting_today_pill_number_state.codegen.freezed.dart';

@freezed
class SettingTodayPillNumberState with _$SettingTodayPillNumberState {
  const SettingTodayPillNumberState._();
  const factory SettingTodayPillNumberState({
    required Setting? setting,
    @Default(0) int selectedPillSheetPageIndex,
    @Default(0) int selectedPillMarkNumberIntoPillSheet,
    required PillSheetAppearanceMode appearanceMode,
    required bool isTrial,
    required bool isPremium,
  }) = _SettingTodayPillNumberState;

  int? selectedTodayPillNumberIntoPillSheet(int pageIndex) {
    if (selectedPillSheetPageIndex != pageIndex) {
      return null;
    }
    return selectedPillMarkNumberIntoPillSheet;
  }
}
