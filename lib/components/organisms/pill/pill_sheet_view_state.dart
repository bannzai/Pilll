import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';

part 'pill_sheet_view_state.freezed.dart';

@freezed
abstract class PillSheetViewState implements _$PillSheetViewState {
  PillSheetViewState._();
  factory PillSheetViewState({
    required PillSheet pillSheet,
  }) = _PillSheetViewState;
}
