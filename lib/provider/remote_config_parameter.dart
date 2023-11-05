import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/utils/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_parameter.g.dart';

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
}
