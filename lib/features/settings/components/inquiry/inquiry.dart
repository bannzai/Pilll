import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../entity/user.codegen.dart';

Future<String> debugInfo(String separator) async {
  final userID = auth.FirebaseAuth.instance.currentUser?.uid;
  if (userID == null) {
    final sharedPreferences = await SharedPreferences.getInstance();
    return Future.value('DEBUG INFO user is not found. lastest last login id ${sharedPreferences.getString(StringKey.lastSignInAnonymousUID)}');
  }

  DatabaseConnection databaseConnection = DatabaseConnection(userID);

  User? user;
  try {
    user = (await databaseConnection.userReference().get()).data();
  } catch (_) {}

  PillSheetGroup? pillSheetGroup;
  try {
    pillSheetGroup = await fetchLatestPillSheetGroup(databaseConnection);
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
  final platform = Platform.isIOS ? 'iOS' : 'Android';

  final activePillSheet = pillSheetGroup?.activePillSheet;
  final Map<String, dynamic> activedPillSheetDebugInfo = <String, dynamic>{};
  if (activePillSheet != null) {
    activedPillSheetDebugInfo['id'] = activePillSheet.id;
    activedPillSheetDebugInfo['beginingDate'] = activePillSheet.beginDate.toIso8601String();
    activedPillSheetDebugInfo['lastTakenDate'] = activePillSheet.lastTakenDate?.toIso8601String();
    activedPillSheetDebugInfo['createdAt'] = activePillSheet.createdAt?.toIso8601String();
    activedPillSheetDebugInfo['deletedAt'] = activePillSheet.deletedAt?.toIso8601String();
  }

  final contents = [
    'DEBUG INFO',
    "$platform:$appName:$version:$packageName:$buildNumber:${Environment.isProduction ? "prod" : "dev"}",
    'userID: $userID',
    'isPremium: ${user?.isPremium}',
    'isTrial: ${user?.isTrial}',
    'pillSheetGroupID: ${pillSheetGroup?.id}',
    'activePillSheet: ${activedPillSheetDebugInfo.toString()}',
    'reminderTimes: ${setting?.reminderTimes}',
  ];
  return contents.join(separator);
}
