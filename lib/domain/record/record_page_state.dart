import 'package:pilll/entity/pill_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/setting.dart';

part 'record_page_state.freezed.dart';

@freezed
abstract class RecordPageState implements _$RecordPageState {
  RecordPageState._();
  factory RecordPageState({
    required PillSheet? entity,
    Setting? setting,
    @Default(false) bool firstLoadIsEnded,
  }) = _RecordPageState;

  bool get isInvalid => entity == null || entity!.isInvalid;
}
