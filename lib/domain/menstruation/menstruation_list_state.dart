import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';

part 'menstruation_list_state.freezed.dart';

@freezed
abstract class MenstruationListState implements _$MenstruationListState {
  MenstruationListState._();
  factory MenstruationListState({
    @Default(true) bool isNotYetLoaded,
    @Default([]) List<MenstruationHistoryRowState> allRows,
  }) = _MenstruationListState;

  List<MenstruationHistoryRowState> get rows {
    if (isPremium || isTrial) {
      return allRows;
    }
    if (allRows.length <= 2) {
      return allRows;
    }
    return allRows.sublist(0, 2);
  }

  List<MenstruationHistoryRowState> get lockedRows {
    if (allRows.length == rows.length) {
      return [];
    }
    return allRows.sublist(rows.length);
  }
}
