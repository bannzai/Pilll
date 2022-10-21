import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

part 'notification_bar_state.codegen.freezed.dart';

@freezed
class NotificationBarState with _$NotificationBarState {
  const NotificationBarState._();
  const factory NotificationBarState({
    required PillSheetGroup? latestPillSheetGroup,
    required int totalCountOfActionForTakenPill,
    required PremiumAndTrial premiumAndTrial,
    required bool recommendedSignupNotificationIsAlreadyShow,
    required bool isLinkedLoginProvider,
    required bool premiumUserIsClosedAdsMederiPill,
    required bool userAnsweredSurvey,
    required bool userClosedSurvey,
  }) = _NotificationBarState;

  bool get shownRecommendSignupNotificationForPremium {
    if (isLinkedLoginProvider) {
      return false;
    }
    if (!premiumAndTrial.isPremium) {
      return false;
    }
    return true;
  }

  String? get restDurationNotification {
    final activedPillSheet = latestPillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      return null;
    }
    if (activedPillSheet.deletedAt != null) {
      return null;
    }
    final restDuration = activedPillSheet.activeRestDuration;
    if (restDuration != null) {
      final day = daysBetween(restDuration.beginDate.date(), today()) + 1;
      return "休薬$day日目";
    }

    if (activedPillSheet.typeInfo.dosingPeriod < activedPillSheet.todayPillNumber) {
      final day = activedPillSheet.todayPillNumber - activedPillSheet.typeInfo.dosingPeriod;
      return "${activedPillSheet.pillSheetType.notTakenWord}$day日目";
    }

    const threshold = 4;
    if (activedPillSheet.pillSheetType.notTakenWord.isNotEmpty) {
      if (activedPillSheet.typeInfo.dosingPeriod - threshold + 1 < activedPillSheet.todayPillNumber) {
        final diff = activedPillSheet.typeInfo.dosingPeriod - activedPillSheet.todayPillNumber;
        return "あと${diff + 1}日で${activedPillSheet.pillSheetType.notTakenWord}期間です";
      }
    }
    return null;
  }

  String? get premiumTrialLimit {
    if (premiumAndTrial.isPremium) {
      return null;
    }
    if (!premiumAndTrial.isTrial) {
      return null;
    }
    final trialDeadlineDate = premiumAndTrial.trialDeadlineDate;
    if (trialDeadlineDate == null) {
      return null;
    }

    if (trialDeadlineDate.isBefore(now())) {
      return null;
    }

    final diff = daysBetween(now(), trialDeadlineDate);
    return "残り$diff日間すべての機能を使えます";
  }
}
