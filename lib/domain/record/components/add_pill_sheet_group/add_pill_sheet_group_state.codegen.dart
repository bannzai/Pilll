import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'add_pill_sheet_group_state.codegen.freezed.dart';

@freezed
class AddPillSheetGroupState with _$AddPillSheetGroupState {
  factory AddPillSheetGroupState({
    required PillSheetGroup? pillSheetGroup,
    required Setting? setting,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    PillSheetGroupDisplayNumberSetting? displayNumberSetting,
  }) = _AddPillSheetGroupState;
  AddPillSheetGroupState._();
}
