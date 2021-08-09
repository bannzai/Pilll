import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

part 'pill_sheet_modified_history_state.freezed.dart';

@freezed
abstract class PillSheetModifiedHistoryState
    implements _$PillSheetModifiedHistoryState {
  PillSheetModifiedHistoryState._();
  factory PillSheetModifiedHistoryState({
    @Default(false) bool isFirstLoadEnded,
    @Default(false) bool isLoading,
    @Default([]) List<PillSheetModifiedHistoryElementState> elements,
  }) = _PillSheetModifiedHistoryState;
}

@freezed
abstract class PillSheetModifiedHistoryElementState
    implements _$PillSheetModifiedHistoryElementState {
  PillSheetModifiedHistoryElementState._();
  factory PillSheetModifiedHistoryElementState({
    required PillSheetModifiedActionType actionType,
    required PillSheetModifiedHistoryValue value,
    required DateTime createdAt,
  }) = _PillSheetModifiedHistoryElementState;
}
