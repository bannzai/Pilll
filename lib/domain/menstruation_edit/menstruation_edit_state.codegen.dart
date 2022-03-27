import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.dart';

part 'menstruation_edit_state.freezed.dart';

@freezed
class MenstruationEditState with _$MenstruationEditState {
  const MenstruationEditState._();
  const factory MenstruationEditState({
    @Default(false) bool isAlreadyAdjsutScrollOffset,
    required Menstruation? menstruation,
    required List<DateTime> displayedDates,
    @Default(false) isPremium,
    @Default(false) isTrial,
    String? invalidMessage,
  }) = _MenstruationEditState;

  List<DateTime> dates() => displayedDates;
}
