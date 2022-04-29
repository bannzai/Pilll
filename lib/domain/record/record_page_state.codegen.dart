import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/provider/shared_preference.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/util/shared_preference/keys.dart';

part 'record_page_state.codegen.freezed.dart';

@freezed
class RecordPageState with _$RecordPageState {
  const RecordPageState._();
  const factory RecordPageState({
    required PillSheetGroup? pillSheetGroup,
    required Setting setting,
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
    return setting.pillSheetAppearanceMode;
  }
}

final recordPageAsyncStateProvider =
    Provider<AsyncValue<RecordPageState>>((ref) {
  final latestPillSheetGroup = ref.watch(latestPillSheetGroupStreamProvider);
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);
  final setting = ref.watch(settingStreamProvider);
  final sharedPreferencesAsyncValue = ref.watch(sharedPreferenceProvider);

  if (latestPillSheetGroup is AsyncLoading ||
      premiumAndTrial is AsyncLoading ||
      setting is AsyncLoading ||
      sharedPreferencesAsyncValue is AsyncLoading) {
    return const AsyncValue.loading();
  }

  final sharedPreferences = sharedPreferencesAsyncValue.value!;

  try {
    return AsyncValue.data(RecordPageState(
      pillSheetGroup: latestPillSheetGroup.value,
      setting: setting.value!,
      premiumAndTrial: premiumAndTrial.value!,
      totalCountOfActionForTakenPill:
          sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0,
      shouldShowMigrateInfo:
          ref.watch(shouldShowMigrationInformationProvider(sharedPreferences)),
      isAlreadyShowTiral:
          sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumTrialModal) ??
              false,
      isAlreadyShowPremiumSurvey:
          sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumSurvey) ??
              false,
      recommendedSignupNotificationIsAlreadyShow: sharedPreferences
              .getBool(BoolKey.recommendedSignupNotificationIsAlreadyShow) ??
          false,
      premiumTrialGuideNotificationIsClosed: sharedPreferences
              .getBool(BoolKey.premiumTrialGuideNotificationIsClosed) ??
          false,
      premiumTrialBeginAnouncementIsClosed: sharedPreferences
              .getBool(BoolKey.premiumTrialBeginAnouncementIsClosed) ??
          false,
      isLinkedLoginProvider: ref.watch(isLinkedProvider),
    ));
  } catch (error, stackTrace) {
    errorLogger.recordError(error, stackTrace);
    return AsyncValue.error(error);
  }
});
