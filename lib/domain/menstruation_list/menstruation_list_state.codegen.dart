import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

part 'menstruation_list_state.codegen.freezed.dart';

@freezed
class MenstruationListState with _$MenstruationListState {
  const MenstruationListState._();
  const factory MenstruationListState({
    @Default(true) bool isNotYetLoaded,
    @Default([]) List<Menstruation> allMenstruations,
  }) = _MenstruationListState;
}
