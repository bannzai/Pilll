import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/setting.dart';

part 'setting_today_pill_number_state.freezed.dart';

@freezed
class SettingTodayPillNumberState with _$SettingTodayPillNumberState {
  const SettingTodayPillNumberState._();
  const factory SettingTodayPillNumberState({
    @Default(0) int selectedPillSheetPageIndex,
    @Default(0) int selectedPillMarkNumberIntoPillSheet,
    required PillSheetAppearanceMode appearanceMode,
  }) = _SettingTodayPillNumberState;

  int? selectedTodayPillNumberIntoPillSheet(int pageIndex) {
    if (selectedPillSheetPageIndex != pageIndex) {
      return null;
    }
    return selectedPillMarkNumberIntoPillSheet;
  }
}
