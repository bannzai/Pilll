import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/datetime/day.dart';

part 'notification_bar_state.freezed.dart';

@freezed
abstract class NotificationBarState implements _$NotificationBarState {
  NotificationBarState._();
  factory NotificationBarState({
    required PillSheetGroup? latestPillSheetGroup,
    required int totalCountOfActionForTakenPill,
    required bool isPremium,
    required bool isTrial,
    required bool hasDiscountEntitlement,
    required DateTime? trialDeadlineDate,
    required DateTime? discountEntitlementDeadlineDate,
    required bool recommendedSignupNotificationIsAlreadyShow,
    required bool premiumTrialGuideNotificationIsClosed,
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
    if (activedPillSheet.pillSheetType.isNotExistsNotTakenDuration) {
      return null;
    }
    if (activedPillSheet.typeInfo.dosingPeriod <
        activedPillSheet.todayPillNumber) {
      return "${activedPillSheet.pillSheetType.notTakenWord}期間中";
    }

    final threshold = 4;
    if (activedPillSheet.typeInfo.dosingPeriod - threshold + 1 <
        activedPillSheet.todayPillNumber) {
      final diff = activedPillSheet.typeInfo.dosingPeriod -
          activedPillSheet.todayPillNumber;
      return "あと${diff + 1}日で${activedPillSheet.pillSheetType.notTakenWord}期間です";
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

    assert(trialDeadlineDate.isAfter(now()), "It is end of trial period.");
    if (trialDeadlineDate.isBefore(now())) {
      return null;
    }

    final diff = trialDeadlineDate.difference(now()).inDays + 1;
    if (diff < 0) {
      return null;
    }
    if (diff > 10) {
      return null;
    }
    return "プレミアムお試し体験中（残り$diff日）";
  }
}
