import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> setupRemoteConfig() async {
  await (
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    )),
    remoteConfig.setDefaults({
      RemoteConfigKeys.isPaywallFirst: RemoteConfigParameterDefaultValues.isPaywallFirst,
      RemoteConfigKeys.skipOnBoarding: RemoteConfigParameterDefaultValues.skipOnBoarding,
      RemoteConfigKeys.trialDeadlineDateOffsetDay: RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
      RemoteConfigKeys.discountEntitlementOffsetDay: RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
      RemoteConfigKeys.discountCountdownBoundaryHour: RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
    }),
    remoteConfig.fetchAndActivate()
  ).wait;

  debugPrintRemoteConfig();

  remoteConfig.onConfigUpdated.listen((event) {
    remoteConfig.activate();
  });
}

void debugPrintRemoteConfig() {
  for (final entry in remoteConfig.getAll().entries) {
    debugPrint("RemoteConfig: ${entry.key} ${entry.value.asString()}");
  }
}
