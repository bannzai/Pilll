import 'package:pilll/entity/pill_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_page_state.freezed.dart';

@freezed
abstract class RecordPageState implements _$RecordPageState {
  RecordPageState._();
  factory RecordPageState({required PillSheetModel? entity}) = _RecordPageState;

  bool get isInvalid => entity == null || entity!.isDeleted || entity!.isEnded;
}
