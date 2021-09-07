import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';

part 'record_page_state.freezed.dart';

@freezed
abstract class RecordPageState implements _$RecordPageState {
  RecordPageState._();
  factory RecordPageState({
    PillSheetGroup? pillSheetGroup,
    Setting? setting,
    @Default(0) int totalCountOfActionForTakenPill,
    @Default(false) bool firstLoadIsEnded,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    @Default(false) bool hasDiscountEntitlement,
    @Default(false) bool isAlreadyShowTiral,
    @Default(false) bool shouldShowMigrateInfo,
    @Default(false) bool isLinkedLoginProvider,
    DateTime? beginTrialDate,
    DateTime? trialDeadlineDate,
    DateTime? discountEntitlementDeadlineDate,
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
    @Default(true) bool premiumTrialGuideNotificationIsClosed,
    Object? exception,
  }) = _RecordPageState;

  bool get isUserInteractionDisabled {
    final pillSheetGroup = this.pillSheetGroup;
    return pillSheetGroup == null ||
        pillSheetGroup.isDeactive ||
        pillSheetGroup.isDeleted;
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

  PillSheetAppearanceMode get appearanceMode {
    return setting?.pillSheetAppearanceMode ?? PillSheetAppearanceMode.number;
  }
}
