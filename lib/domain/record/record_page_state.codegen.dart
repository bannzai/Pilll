import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'record_page_state.codegen.freezed.dart';

@freezed
class RecordPageState with _$RecordPageState {
  const RecordPageState._();
  const factory RecordPageState({
    PillSheetGroup? pillSheetGroup,
    Setting? setting,
    @Default(0) int totalCountOfActionForTakenPill,
    @Default(false) bool firstLoadIsEnded,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    @Default(false) bool hasDiscountEntitlement,
    @Default(false) bool isAlreadyShowTiral,
    @Default(false) bool isAlreadyShowPremiumSurvey,
    @Default(false) bool shouldShowMigrateInfo,
    @Default(false) bool isLinkedLoginProvider,
    DateTime? beginTrialDate,
    DateTime? trialDeadlineDate,
    DateTime? discountEntitlementDeadlineDate,
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
    @Default(true) bool premiumTrialGuideNotificationIsClosed,
    @Default(true) bool premiumTrialBeginAnouncementIsClosed,
    Object? exception,
  }) = _RecordPageState;

  int get initialPageIndex {
    return pillSheetGroup?.activedPillSheet?.groupIndex ?? 0;
  }

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
    if (totalCountOfActionForTakenPill < 42) {
      return false;
    }
    return true;
  }

  bool get shouldShowPremiumFunctionSurvey {
    if (shouldShowTrial) {
      return false;
    }
    if (isPremium || isTrial) {
      return false;
    }
    final isNotYetStartTrial = trialDeadlineDate == null;
    if (isNotYetStartTrial) {
      return false;
    }
    return !isAlreadyShowPremiumSurvey;
  }

  PillSheetAppearanceMode get appearanceMode {
    return setting?.pillSheetAppearanceMode ?? PillSheetAppearanceMode.number;
  }
}
