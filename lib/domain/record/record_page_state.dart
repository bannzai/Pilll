import 'package:pilll/entity/pill_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

part 'record_page_state.freezed.dart';

@freezed
abstract class RecordPageState implements _$RecordPageState {
  RecordPageState._();
  factory RecordPageState({
    required PillSheet? entity,
    Setting? setting,
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
    @Default(false) bool isLinkedLoginProvider,
    @Default(false) bool firstLoadIsEnded,
  }) = _RecordPageState;

  bool get isInvalid => entity == null || entity!.isInvalid;
  String get restDurationNotification {
    if (isInvalid) {
      return "";
    }
    final pillSheet = entity;
    if (pillSheet == null) {
      return "";
    }
    if (pillSheet.pillSheetType.isNotExistsNotTakenDuration) {
      return "";
    }
    if (pillSheet.typeInfo.dosingPeriod < pillSheet.todayPillNumber) {
      return "${pillSheet.pillSheetType.notTakenWord}期間中";
    }

    final threshold = 4;
    if (pillSheet.typeInfo.dosingPeriod - threshold + 1 <
        pillSheet.todayPillNumber) {
      final diff = pillSheet.typeInfo.dosingPeriod - pillSheet.todayPillNumber;
      return "あと${diff + 1}日で${pillSheet.pillSheetType.notTakenWord}期間です";
    }

    return "";
  }

  String get recommendedSignupNotification {
    if (isLinkedLoginProvider) {
      return "";
    }
    if (recommendedSignupNotificationIsAlreadyShow) {
      return "";
    }
    return "機種変更やスマホ紛失時に備えてアカウント登録しませんか？";
  }
}
