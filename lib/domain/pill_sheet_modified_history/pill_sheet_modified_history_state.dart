import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_sheet_modified_history_state.freezed.dart';

@freezed
abstract class PillSheetModifiedHistoryState
    implements _$PillSheetModifiedHistoryState {
  PillSheetModifiedHistoryState._();
  factory PillSheetModifiedHistoryState({
    DateTime? beginTrialDate,
    @Default(false) bool isTrial,
    @Default(false) bool isPremium,
    @Default(false) bool isLoading,
    @Default(false) bool isFirstLoadEnded,
    Object? exception,
  }) = _PillSheetModifiedHistoryState;
}
