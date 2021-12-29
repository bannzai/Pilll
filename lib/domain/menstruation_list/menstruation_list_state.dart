import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_row.dart';

part 'menstruation_list_state.freezed.dart';

@freezed
class MenstruationListState with _$MenstruationListState {
  MenstruationListState._();
  factory MenstruationListState({
    @Default(true) bool isNotYetLoaded,
    @Default([]) List<MenstruationListRowState> allRows,
  }) = _MenstruationListState;
}
