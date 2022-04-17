import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_pill_sheet_group_state.codegen.freezed.dart';

@freezed
class AddPillSheetGroupStateState with _$AddPillSheetGroupStateState {
  factory AddPillSheetGroupStateState({
    DateTime? beginTrialDate,
    @Default(false) bool isTrial,
    @Default(false) bool isPremium,
    @Default(false) bool isLoading,
    @Default(false) bool isFirstLoadEnded,
    Object? exception,
  }) = _AddPillSheetGroupStateState;
  AddPillSheetGroupStateState._();
}
