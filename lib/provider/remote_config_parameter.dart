import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_parameter.g.dart';

@Riverpod()
RemoteConfigParameter remoteConfigParameter(RemoteConfigParameterRef ref) {
  // fetchAndActiveをentrypointで完了しているので値が取れる想定
  return RemoteConfigParameter(
    isPaywallFirst: remoteConfig.getBool(RemoteConfigKeys.isPaywallFirst),
    isUnnecessaryOnBoarding: remoteConfig.getBool(RemoteConfigKeys.isUnnecessaryOnBoarding),
    trialDeadlineDateOffsetDay: remoteConfig.getInt(RemoteConfigKeys.trialDeadlineDateOffsetDay),
    discountEntitlementOffsetDay: remoteConfig.getInt(RemoteConfigKeys.discountEntitlementOffsetDay),
    discountCountdownBoundaryHour: remoteConfig.getInt(RemoteConfigKeys.discountCountdownBoundaryHour),
  );
}
