import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/version/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config.g.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> setupRemoteConfig() async {
  try {
    await (
      remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      )),
      remoteConfig.setDefaults({
        RemoteConfigKeys.isPaywallFirst: RemoteConfigParameterDefaultValues.isPaywallFirst,
        RemoteConfigKeys.skipInitialSetting: RemoteConfigParameterDefaultValues.skipInitialSetting,
        RemoteConfigKeys.trialDeadlineDateOffsetDay: RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
        RemoteConfigKeys.discountEntitlementOffsetDay: RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
        RemoteConfigKeys.discountCountdownBoundaryHour: RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
        RemoteConfigKeys.releasedVersion: RemoteConfigParameterDefaultValues.releasedVersion,
      }),
      remoteConfig.fetchAndActivate()
    ).wait;

    debugPrintRemoteConfig();

    remoteConfig.onConfigUpdated.listen((event) {
      remoteConfig.activate();
    });
  } catch (error, st) {
    // ignore error
    // ParallelWaitErrorとentrypointでRemoteConfigを導入してからエラーが出るようになった。RemoteConfigの設定は失敗しても最悪どうにかなるだろう。ということでエラーは無視する
    debugPrint(error.toString());
    errorLogger.recordError(error, st);
  }
}

@Riverpod()
Future<bool> appIsReleased(AppIsReleasedRef ref) async {
  final releasedVersion = Version.parse(remoteConfig.getString(RemoteConfigKeys.releasedVersion));
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersion = Version.parse(packageInfo.version);
  return !appVersion.isGreaterThan(releasedVersion);
}

void debugPrintRemoteConfig() {
  for (final entry in remoteConfig.getAll().entries) {
    debugPrint("RemoteConfig: ${entry.key} ${entry.value.asString()}");
  }
}
