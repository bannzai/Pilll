import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card.dart';

part 'menstruation_list_state.freezed.dart';

@freezed
abstract class MenstruationListState implements _$MenstruationListState {
  MenstruationListState._();
  factory MenstruationListState({
    required List<MenstruationHistoryCardState> cards,
  }) = _MenstruationListState;

  String get variable => "";
}
