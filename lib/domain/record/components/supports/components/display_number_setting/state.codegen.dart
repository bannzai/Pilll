import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

part 'state.codegen.freezed.dart';

@freezed
class DisplayNumberSettingState with _$DisplayNumberSettingState {
  factory DisplayNumberSettingState({
    PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup pillSheetGroup,
    required PillSheetGroup originalPillSheetGroup,
  }) = _DisplayNumberSettingState;
  DisplayNumberSettingState._();
}
