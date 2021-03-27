import 'package:pilll/entity/pill_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_sheet.freezed.dart';

@freezed
abstract class PillSheetState implements _$PillSheetState {
  PillSheetState._();
  factory PillSheetState({required PillSheetModel? entity}) = _PillSheetState;

  bool get isInvalid => entity == null || entity!.isDeleted || entity!.isEnded;
}
