import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/datetime/day.dart';

part 'notification_bar_state.freezed.dart';

@freezed
abstract class NotificationBarState implements _$NotificationBarState {
  NotificationBarState._();
  factory NotificationBarState({
    required PillSheet? pillSheet,
    required int totalCountOfActionForTakenPill,
    @Default(false) bool isLinkedLoginProvider,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? trialDeadlineDate,
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
    @Default(true) bool premiumTrialGuideNotificationIsClosed,
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
    final pillSheet = this.pillSheet;
    if (pillSheet == null || pillSheet.isInvalid) {
      return null;
    }
    if (pillSheet.pillSheetType.isNotExistsNotTakenDuration) {
      return null;
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

    return null;
  }

  String? get premiumTrialLimit {
    if (!isTrial) {
      return null;
    }
    final trialDeadlineDate = this.trialDeadlineDate;
    assert(trialDeadlineDate != null,
        "if is trial should fill of trialDeadlineDate");
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
