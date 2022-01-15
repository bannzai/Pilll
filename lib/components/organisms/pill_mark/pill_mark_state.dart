import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

part 'pill_mark_state.freezed.dart';

@freezed
class PillMarkState with _$PillMarkState {
  factory PillMarkState({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
    required PillSheetGroup pillSheetGroup,
  }) = _PillMarkState;
  PillMarkState._();
}
