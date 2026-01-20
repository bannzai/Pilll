import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/version/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config.g.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> setupRemoteConfig() async {
  try {
    await (
      remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      ),
      // [RemoteConfigDefaultValues] でgrepした場所に全て設定する
      remoteConfig.setDefaults({
        RemoteConfigKeys.isPaywallFirst:
            RemoteConfigParameterDefaultValues.isPaywallFirst,
        RemoteConfigKeys.skipInitialSetting:
            RemoteConfigParameterDefaultValues.skipInitialSetting,
        RemoteConfigKeys.trialDeadlineDateOffsetDay:
            RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
        RemoteConfigKeys.discountEntitlementOffsetDay:
            RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
        RemoteConfigKeys.discountCountdownBoundaryHour:
            RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
        RemoteConfigKeys.releasedVersion:
            RemoteConfigParameterDefaultValues.releasedVersion,
        RemoteConfigKeys.premiumIntroductionPattern:
            RemoteConfigParameterDefaultValues.premiumIntroductionPattern,
        RemoteConfigKeys.premiumIntroductionShowsAppStoreReviewCard:
            RemoteConfigParameterDefaultValues
                .premiumIntroductionShowsAppStoreReviewCard,
        RemoteConfigKeys.specialOfferingUserCreationDateTimeOffset:
            RemoteConfigParameterDefaultValues
                .specialOfferingUserCreationDateTimeOffset,
        RemoteConfigKeys.specialOfferingUserCreationDateTimeOffsetSince:
            RemoteConfigParameterDefaultValues
                .specialOfferingUserCreationDateTimeOffsetSince,
        RemoteConfigKeys.specialOfferingUserCreationDateTimeOffsetUntil:
            RemoteConfigParameterDefaultValues
                .specialOfferingUserCreationDateTimeOffsetUntil,
        RemoteConfigKeys.specialOffering2UseAlternativeText:
            RemoteConfigParameterDefaultValues
                .specialOffering2UseAlternativeText,
      }),
    ).wait;
    // 項目が増えて来てfetchが重たくなっていてアプリが開かない説があるので非同期にする。計測はしてない。since: 2025-06-25
    unawaited(() async {
      try {
        await remoteConfig.fetchAndActivate();
      } catch (error, st) {
        debugPrint('Error during fetchAndActivate: ${error.toString()}');
        errorLogger.recordError(error, st);
      }
    }());

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
  if (kDebugMode) {
    return true;
  }
  final releasedVersion = Version.parse(
    remoteConfig.getString(RemoteConfigKeys.releasedVersion),
  );
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersion = Version.parse(packageInfo.version);
  return !appVersion.isGreaterThan(releasedVersion);
}

void debugPrintRemoteConfig() {
  for (final entry in remoteConfig.getAll().entries) {
    debugPrint('RemoteConfig: ${entry.key} ${entry.value.asString()}');
  }
}
