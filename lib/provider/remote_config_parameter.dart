import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/utils/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_parameter.g.dart';

// [RemoteConfigDefaultValues] でgrepした場所に全て設定する
@Riverpod()
RemoteConfigParameter remoteConfigParameter(RemoteConfigParameterRef ref) {
  // fetchAndActiveをentrypointで完了しているので値が取れる想定
  return RemoteConfigParameter(
    isPaywallFirst: remoteConfig.getBoolOrDefault(
      RemoteConfigKeys.isPaywallFirst,
      RemoteConfigParameterDefaultValues.isPaywallFirst,
    ),
    skipInitialSetting: remoteConfig.getBoolOrDefault(
      RemoteConfigKeys.skipInitialSetting,
      RemoteConfigParameterDefaultValues.skipInitialSetting,
    ),
    trialDeadlineDateOffsetDay: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.trialDeadlineDateOffsetDay,
      RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
    ),
    discountEntitlementOffsetDay: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.discountEntitlementOffsetDay,
      RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
    ),
    discountCountdownBoundaryHour: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.discountCountdownBoundaryHour,
      RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
    ),
    premiumIntroductionShowsAppStoreReviewCard: remoteConfig.getBoolOrDefault(
      RemoteConfigKeys.premiumIntroductionShowsAppStoreReviewCard,
      RemoteConfigParameterDefaultValues.premiumIntroductionShowsAppStoreReviewCard,
    ),
    specialOfferingUserCreationDateTimeOffset: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.specialOfferingUserCreationDateTimeOffset,
      RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffset,
    ),
    specialOfferingUserCreationDateTimeOffsetSince: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.specialOfferingUserCreationDateTimeOffsetSince,
      RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetSince,
    ),
    specialOfferingUserCreationDateTimeOffsetUntil: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.specialOfferingUserCreationDateTimeOffsetUntil,
      RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetUntil,
    ),
    specialOffering2UseAlternativeText: remoteConfig.getBoolOrDefault(
      RemoteConfigKeys.specialOffering2UseAlternativeText,
      RemoteConfigParameterDefaultValues.specialOffering2UseAlternativeText,
    ),
    lifetimeOfferEnabled: remoteConfig.getBoolOrDefault(
      RemoteConfigKeys.lifetimeOfferEnabled,
      RemoteConfigParameterDefaultValues.lifetimeOfferEnabled,
    ),
    lifetimeOfferUserCreationDaysSince: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.lifetimeOfferUserCreationDaysSince,
      RemoteConfigParameterDefaultValues.lifetimeOfferUserCreationDaysSince,
    ),
    lifetimeOfferUserCreationDaysUntil: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.lifetimeOfferUserCreationDaysUntil,
      RemoteConfigParameterDefaultValues.lifetimeOfferUserCreationDaysUntil,
    ),
    lifetimeOfferDurationHours: remoteConfig.getIntOrDefault(
      RemoteConfigKeys.lifetimeOfferDurationHours,
      RemoteConfigParameterDefaultValues.lifetimeOfferDurationHours,
    ),
    lifetimeOfferCopyVariant: remoteConfig.getStringOrDefault(
      RemoteConfigKeys.lifetimeOfferCopyVariant,
      RemoteConfigParameterDefaultValues.lifetimeOfferCopyVariant,
    ),
  );
}

extension RemoteConfigExt on FirebaseRemoteConfig {
  bool getBoolOrDefault(String key, bool defaultValue) {
    try {
      return getAll().containsKey(key) ? getBool(key) : defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  int getIntOrDefault(String key, int defaultValue) {
    try {
      return getAll().containsKey(key) ? getInt(key) : defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  String getStringOrDefault(String key, String defaultValue) {
    try {
      // getStringは未設定時に空文字を返すため、空文字ならデフォルトにフォールバックする
      return getString(key).isEmpty ? defaultValue : getString(key);
    } catch (error) {
      return defaultValue;
    }
  }
}
