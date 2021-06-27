import 'package:pilll/entity/firestore_timestamp_converter.dart';
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
    @Default(true)
        bool recommendedSignupNotificationIsAlreadyShow,
    @Default(0)
        int totalCountOfActionForTakenPill,
    @Default(false)
        bool isLinkedLoginProvider,
    @Default(false)
        bool firstLoadIsEnded,
    @Default(false)
        bool isPremium,
    @Default(false)
        bool isTrial,
    @Default(false)
        bool isPillSheetFinishedInThePast,
    @Default(false)
        bool isAlreadyShowTiral,
    @Default(false)
        bool shouldShowMigrateInfo,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? beginTrialDate,
    Object? exception,
  }) = _RecordPageState;

  bool get isInvalid => entity == null || entity!.isInvalid;
  bool get shouldShowTrial {
    if (beginTrialDate != null) {
      return false;
    }
    if (isTrial) {
      return false;
    }
    if (!firstLoadIsEnded) {
      return false;
    }
    if (isAlreadyShowTiral) {
      return false;
    }
    if (!isPillSheetFinishedInThePast) {
      return false;
    }
    if (totalCountOfActionForTakenPill < 14) {
      return false;
    }
    return true;
  }

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

  PillSheetAppearanceMode get appearanceMode {
    return setting?.pillSheetAppearanceMode ?? PillSheetAppearanceMode.number;
  }

  String get recommendedSignupNotification {
    if (isLinkedLoginProvider) {
      return "";
    }
    if (totalCountOfActionForTakenPill < 7) {
      return "";
    }
    if (recommendedSignupNotificationIsAlreadyShow) {
      return "";
    }
    return "機種変更やスマホ紛失時に備えて\nアカウント登録しませんか？";
  }
}
