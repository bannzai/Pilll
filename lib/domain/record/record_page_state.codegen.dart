import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

part 'record_page_state.codegen.freezed.dart';

@freezed
class RecordPageState with _$RecordPageState {
  const RecordPageState._();
  const factory RecordPageState({
    required PillSheetGroup? pillSheetGroup,
    required Setting? setting,
    required PremiumAndTrial premiumAndTrial,
    required int totalCountOfActionForTakenPill,
    required bool isAlreadyShowTiral,
    required bool isAlreadyShowPremiumSurvey,
    required bool shouldShowMigrateInfo,
    required bool recommendedSignupNotificationIsAlreadyShow,
    required bool premiumTrialGuideNotificationIsClosed,
    required bool premiumTrialBeginAnouncementIsClosed,
    required bool isLinkedLoginProvider,
  }) = _RecordPageState;

  int get initialPageIndex {
    return pillSheetGroup?.activedPillSheet?.groupIndex ?? 0;
  }

  bool get shouldShowTrial {
    if (premiumAndTrial.trialIsAlreadyBegin) {
      return false;
    }
    if (premiumAndTrial.isTrial) {
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
    if (premiumAndTrial.premiumOrTrial) {
      return false;
    }
    if (premiumAndTrial.isNotYetStartTrial) {
      return false;
    }
    return !isAlreadyShowPremiumSurvey;
  }

  PillSheetAppearanceMode get appearanceMode {
    return setting?.pillSheetAppearanceMode ?? PillSheetAppearanceMode.number;
  }
}
