import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

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
    @Default(true) bool recommendedSignupNotificationIsAlreadyShow,
  }) = _NotificationBarState;

  String? get recommendedSignupNotification {
    if (isLinkedLoginProvider) {
      return null;
    }
    if (totalCountOfActionForTakenPill < 7) {
      return null;
    }
    if (recommendedSignupNotificationIsAlreadyShow) {
      return null;
    }
    return "機種変更やスマホ紛失時に備えて\nアカウント登録しませんか？";
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
}
