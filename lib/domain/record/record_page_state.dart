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
    @Default(0) int pillSheetCount,
    @Default(0) int menstruationCount,
    @Default(0) int diaryCount,
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
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
    if (recommendedSignupNotificationIsAlreadyShow) {
      return "";
    }
    if (pillSheetCount >= 1 && menstruationCount >= 1) {
      return "現在ピルシート$pillSheetCount枚分、生理$menstruationCount件記録しています\nもしもに備えて引き継ぎ設定しませんか？";
    }
    if (diaryCount >= 5 || menstruationCount >= 1) {
      return "生理履歴$menstruationCount件、体調記録$diaryCount件記録しています\n機種変更やスマホ紛失時に備えませんか？";
    }
    return "";
  }
}
