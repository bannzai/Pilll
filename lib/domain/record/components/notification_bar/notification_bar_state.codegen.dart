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
    required bool userAnsweredSurvey,
    required bool userClosedSurvey,
  }) = _NotificationBarState;
}
