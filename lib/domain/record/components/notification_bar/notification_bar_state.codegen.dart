import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/datetime/day.dart';

part 'notification_bar_state.codegen.freezed.dart';

@freezed
class NotificationBarState with _$NotificationBarState {
  const NotificationBarState._();
  const factory NotificationBarState({
    required PillSheetGroup? latestPillSheetGroup,
    required int totalCountOfActionForTakenPill,
    required bool isPremium,
    required bool isTrial,
    required bool isAlreadyShowAnnouncementSupportedMultilplePillSheet,
    required bool hasDiscountEntitlement,
    required DateTime? beginTrialDate,
    required DateTime? trialDeadlineDate,
    required DateTime? discountEntitlementDeadlineDate,
    required bool recommendedSignupNotificationIsAlreadyShow,
    required bool premiumTrialGuideNotificationIsClosed,
    required bool premiumTrialBeginAnouncementIsClosed,
    required bool isLinkedLoginProvider,
  }) = _NotificationBarState;

  bool get shownRecommendSignupNotificationForPremium {
    if (isLinkedLoginProvider) {
      return false;
    }
    if (!isPremium) {
      return false;
    }
    return true;
  }

  String? get restDurationNotification {
    final activedPillSheet = this.latestPillSheetGroup?.activedPillSheet;
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

    if (activedPillSheet.typeInfo.dosingPeriod <
        activedPillSheet.todayPillNumber) {
      final day = activedPillSheet.todayPillNumber -
          activedPillSheet.typeInfo.dosingPeriod;
      return "${activedPillSheet.pillSheetType.notTakenWord}$day日目";
    }

    final threshold = 4;
    if (activedPillSheet.pillSheetType.notTakenWord.isNotEmpty) {
      if (activedPillSheet.typeInfo.dosingPeriod - threshold + 1 <
          activedPillSheet.todayPillNumber) {
        final diff = activedPillSheet.typeInfo.dosingPeriod -
            activedPillSheet.todayPillNumber;
        return "あと${diff + 1}日で${activedPillSheet.pillSheetType.notTakenWord}期間です";
      }
    }
    return null;
  }

  String? get premiumTrialLimit {
    if (!isTrial) {
      return null;
    }
    final trialDeadlineDate = this.trialDeadlineDate;
    if (trialDeadlineDate == null) {
      return null;
    }

    if (trialDeadlineDate.isBefore(now())) {
      return null;
    }

    final diff = daysBetween(now(), trialDeadlineDate) + 1;
    if (diff < 0) {
      return null;
    }
    if (diff > 10) {
      return null;
    }
    return "プレミアムお試し体験中（残り$diff日）";
  }
}
