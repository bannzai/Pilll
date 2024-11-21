import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/entity/config.codegen.dart';
import 'package:pilll/utils/version/version.dart';

final checkForceUpdateProvider = Provider((ref) => CheckForceUpdate());

class CheckForceUpdate {
// Return false: should not force update
// Return true: should force update
  Future<bool> call() async {
    final doc = await FirebaseFirestore.instance.doc("/globals/config").get();
    final config = Config.fromJson(doc.data() as Map<String, dynamic>);
    final packageVersion = await Version.fromPackage();

    final forceUpdate = packageVersion.isLessThan(Version.parse(config.minimumSupportedAppVersion));
    if (forceUpdate) {
      analytics.logEvent(
        name: "screen_type_force_update",
        parameters: {
          "package_version": packageVersion.toString(),
          "minimum_app_version": config.minimumSupportedAppVersion,
        },
      );
    }
    return forceUpdate;
  }
}
