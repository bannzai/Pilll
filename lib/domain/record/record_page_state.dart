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
    @Default(0) int totalCountOfActionForTakenPill,
    @Default(false) bool firstLoadIsEnded,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    @Default(false) bool isPillSheetFinishedInThePast,
    @Default(false) bool isAlreadyShowTiral,
    @Default(false) bool shouldShowMigrateInfo,
    DateTime? beginTrialDate,
    DateTime? trialDeadlineDate,
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
    @Default(true) bool premiumTrialGuideNotificationIsClosed,
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

  PillSheetAppearanceMode get appearanceMode {
    return setting?.pillSheetAppearanceMode ?? PillSheetAppearanceMode.number;
  }
}
