import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/shared_preference.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';

part 'setting_page_state.codegen.freezed.dart';


final settingStateProvider = Provider<AsyncValue<SettingState>>((ref) {
  final latestPillSheetGroup = ;
  final premiumAndTrial = ;
  final setting = ref.watch(settingProvider);
  final sharedPreferencesAsyncValue = ;
  final isHealthDataAvailable = ;
  final deviceTimezoneName = ;

  if (latestPillSheetGroup is AsyncLoading ||
      premiumAndTrial is AsyncLoading ||
      setting is AsyncLoading ||
      sharedPreferencesAsyncValue is AsyncLoading ||
      isHealthDataAvailable is AsyncLoading ||
      deviceTimezoneName is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    final sharedPreferences = sharedPreferencesAsyncValue.value!;
    final userIsMigratedFrom132 =
        sharedPreferences.containsKey(StringKey.salvagedOldStartTakenDate) && sharedPreferences.containsKey(StringKey.salvagedOldLastTakenDate);

    return AsyncValue.data(
      SettingState(
        latestPillSheetGroup: latestPillSheetGroup.value,
        setting: setting.value!,
        premiumAndTrial: premiumAndTrial.value!,
        isHealthDataAvailable: isHealthDataAvailable.value!,
        userIsUpdatedFrom132: userIsMigratedFrom132,
        deviceTimezoneName: deviceTimezoneName.value!,
      ),
    );
  } catch (error, stacktrace) {
    return AsyncValue.error(error, stacktrace);
  }
});

@freezed
class SettingState with _$SettingState {
  const SettingState._();
  const factory SettingState({
    required Setting setting,
    required PillSheetGroup? latestPillSheetGroup,
    required bool userIsUpdatedFrom132,
    required PremiumAndTrial premiumAndTrial,
    required bool isHealthDataAvailable,
    required String deviceTimezoneName,
  }) = _SettingState;
}
