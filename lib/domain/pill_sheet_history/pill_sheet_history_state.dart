import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';

part 'pill_sheet_history_state.freezed.dart';

@freezed
abstract class PillSheetHistoryState implements _$PillSheetHistoryState {
  PillSheetHistoryState._();
  factory PillSheetHistoryState({
    @Default([]) List<PillSheet> pillSheets,
  }) = _PillSheetHistoryState;
}
