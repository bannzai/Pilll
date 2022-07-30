import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

part 'state.codegen.freezed.dart';

final diarySettingPhysicalConditionDetailAsyncStateProvider = Provider.autoDispose<AsyncValue<DiarySettingPhysicalConditionDetailState>>((ref) {
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

  try {
    final sharedPreferences = sharedPreferencesAsyncValue.value!;

    return AsyncValue.data(RecordPageState(
      pillSheetGroup: latestPillSheetGroup.value,
      setting: setting.value!,
      premiumAndTrial: premiumAndTrial.value!,
      totalCountOfActionForTakenPill: sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0,
      shouldShowMigrateInfo: ref.watch(shouldShowMigrationInformationProvider(sharedPreferences)),
      isAlreadyShowPremiumSurvey: sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumSurvey) ?? false,
      recommendedSignupNotificationIsAlreadyShow: sharedPreferences.getBool(BoolKey.recommendedSignupNotificationIsAlreadyShow) ?? false,
      premiumTrialBeginAnouncementIsClosed: sharedPreferences.getBool(BoolKey.premiumTrialBeginAnouncementIsClosed) ?? false,
      isLinkedLoginProvider: ref.watch(isLinkedProvider),
      timestamp: now(),
    ));
  } catch (error, stackTrace) {
    errorLogger.recordError(error, stackTrace);
    return AsyncValue.error(error, stackTrace: stackTrace);
  }
});

@freezed
class DiarySettingPhysicalConditionDetailState with _$DiarySettingPhysicalConditionDetailState {
  factory DiarySettingPhysicalConditionDetailState({
    required DiarySetting diarySetting,
  }) = _DiarySettingPhysicalConditionDetailState;
  DiarySettingPhysicalConditionDetailState._();
}
