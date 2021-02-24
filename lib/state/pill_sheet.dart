import 'package:Pilll/entity/pill_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_sheet.freezed.dart';

@freezed
abstract class PillSheetState implements _$PillSheetState {
  PillSheetState._();
  factory PillSheetState({List<PillSheetModel> entities}) = _PillSheetState;
  factory PillSheetState.one({PillSheetModel latestPillSheet}) =>
      PillSheetState(entities: [latestPillSheet]);

  PillSheetModel get latestPillSheet => entities.last;

  bool get latestIsInvalid =>
      latestPillSheet == null ||
      latestPillSheet.isDeleted ||
      latestPillSheet.isEnded;

  PillSheetState copyWithLatestPillSheet(PillSheetModel entity) {
    if (this.entities.isEmpty) {
      return copyWith(entities: [entity]);
    }
    var entities = this.entities;
    entities[0] = entity;
    return copyWith(entities: entities);
  }
}
