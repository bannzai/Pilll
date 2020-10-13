import 'package:Pilll/model/pill_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_sheet.freezed.dart';

@freezed
abstract class PillSheetState implements _$PillSheetState {
  PillSheetState._();
  factory PillSheetState({@Default(null) PillSheetModel entity}) =
      _PillSheetState;
}
