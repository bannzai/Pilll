import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/util/environment.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../entity/user.codegen.dart';

inquiry() {
  PackageInfo.fromPlatform().then((value) => debugInfo(", ")).then((info) {
    launchUrl(
        Uri.parse(Uri.encodeFull(
            "https://docs.google.com/forms/d/e/1FAIpQLSddEpE641jIKEL9cxgiKaRytmBtsP7PXnDdXonEyE-n62JMWQ/viewform?usp=pp_url&entry.2066946565=$info")),
        mode: LaunchMode.inAppWebView);
  });
}

Future<String> debugInfo(String separator) async {
  final userID = auth.FirebaseAuth.instance.currentUser?.uid;
  if (userID == null) {
    return Future.value("DEBUG INFO user is not found");
  }

  DatabaseConnection databaseConnection = DatabaseConnection(userID);

  User? user;
  try {
    user = (await databaseConnection.userReference().get()).data();
  } catch (_) {}

  PillSheetGroup? pillSheetGroup;
  try {
    pillSheetGroup = databaseConnection.pillSheetGroupReference(pillSheetGroupID)
  } catch (_) {}

  Setting? setting;
  try {
    setting = await databaseConnection.userReference().get().then((event) => event.data()?.setting);
  } catch (_) {}

  PackageInfo? package;
  try {
    package = await PackageInfo.fromPlatform();
  } catch (_) {}
  final appName = package?.appName;
  final buildNumber = package?.buildNumber;
  final packageName = package?.packageName;
  final version = package?.version;
  final platform = Platform.isIOS ? "iOS" : "Android";

  final activedPillSheet = pillSheetGroup?.activedPillSheet;
  final Map<String, dynamic> activedPillSheetDebugInfo = <String, dynamic>{};
  if (activedPillSheet != null) {
    activedPillSheetDebugInfo["id"] = activedPillSheet.id;
    activedPillSheetDebugInfo["beginingDate"] = activedPillSheet.beginingDate.toIso8601String();
    activedPillSheetDebugInfo["lastTakenDate"] = activedPillSheet.lastTakenDate?.toIso8601String();
    activedPillSheetDebugInfo["createdAt"] = activedPillSheet.createdAt?.toIso8601String();
    activedPillSheetDebugInfo["deletedAt"] = activedPillSheet.deletedAt?.toIso8601String();
  }

  final contents = [
    "DEBUG INFO",
    "$platform:$appName:$version:$packageName:$buildNumber:${Environment.isProduction ? "prod" : "dev"}",
    "userID: $userID",
    "isPremium: ${user?.isPremium}",
    "isTrial: ${user?.isTrial}",
    "pillSheetGroupID: ${pillSheetGroup?.id}",
    "activedPillSheet: ${activedPillSheetDebugInfo.toString()}",
    "reminderTimes: ${setting?.reminderTimes}",
  ];
  return contents.join(separator);
}
