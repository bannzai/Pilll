import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';

part 'pill_sheet_modified_history_state.freezed.dart';

@freezed
class PillSheetModifiedHistoryState with _$PillSheetModifiedHistoryState {
  PillSheetModifiedHistoryState._();
  factory PillSheetModifiedHistoryState({
    @Default(false) bool isFirstLoadEnded,
    @Default(false) bool isLoading,
    @Default([]) List<PillSheetModifiedHistory> pillSheetModifiedHistories,
  }) = _PillSheetModifiedHistoryState;
}
