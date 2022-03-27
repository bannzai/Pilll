import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';

part 'setting_today_pill_number_store_parameter.freezed.dart';

@freezed
class SettingTodayPillNumberStoreParameter
    with _$SettingTodayPillNumberStoreParameter {
  const factory SettingTodayPillNumberStoreParameter({
    required PillSheetGroup pillSheetGroup,
    required PillSheetAppearanceMode appearanceMode,
    required PillSheet activedPillSheet,
  }) = _SettingTodayPillNumberStoreParameter;
}
