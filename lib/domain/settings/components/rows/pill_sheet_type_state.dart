import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';

part 'pill_sheet_type_state.freezed.dart';

@freezed
abstract class PillSheetTypeState implements _$PillSheetTypeState {
  PillSheetTypeState._();
  factory PillSheetTypeState({
    required Setting? setting,
    required PillSheet? pillSheet,
    Object? exception,
  }) = _PillSheetTypeState;
}
