import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';

Future<void> syncActivePillSheetValue({
  required PillSheetGroup? pillSheetGroup,
}) async {
  final map = {
    "pillSheetLastTakenDate": pillSheetGroup?.activePillSheet?.lastTakenDate?.millisecondsSinceEpoch,
    "pillSheetTodayPillNumber": pillSheetGroup?.activePillSheet?.todayPillNumber,
    "pillSheetGroupTodayPillNumber": pillSheetGroup?.sequentialTodayPillNumber,
    "pillSheetEndDisplayPillNumber": pillSheetGroup?.displayNumberSetting?.endPillNumber,
    "pillSheetValueLastUpdateDateTime": DateTime.now().millisecondsSinceEpoch,
  };
  try {
    await methodChannel.invokeMethod("syncActivePillSheetValue", map);
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<void> syncSetting({
  required Setting? setting,
}) async {
  final map = {
    "settingPillSheetAppearanceMode": setting?.pillSheetAppearanceMode.name,
  };
  try {
    await methodChannel.invokeMethod("syncSetting", map);
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<void> syncUserStatus({
  required User? user,
}) async {
  final map = {
    "userIsPremiumOrTrial": user?.premiumOrTrial,
  };
  await methodChannel.invokeMethod("syncUserStatus", map);
}

const pilllHomeWidgetMethodChannelKey = 'pilll/home_widget/background';

/// Dispatcher used for calling dart code from Native Code while in the background
@pragma("vm:entry-point")
Future<void> callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  const backgroundChannel = MethodChannel(pilllHomeWidgetMethodChannelKey);
  backgroundChannel.setMethodCallHandler((call) async {
    await handleInteractiveWidgetTakenPill();
  });

  await backgroundChannel.invokeMethod('HomeWidget.backgroundInitialized');
}

@pragma("vm:entry-point")
Future<PillSheetGroup?> handleInteractiveWidgetTakenPill() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    return null;
  }

  final database = DatabaseConnection(firebaseUser.uid);
  final pillSheetGroup = await fetchLatestPillSheetGroup(database);
  if (pillSheetGroup == null) {
    return null;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    return pillSheetGroup;
  }
  if (activePillSheet.todayPillIsAlreadyTaken) {
    return pillSheetGroup;
  }

  final takenDate = now();
  final batchFactory = BatchFactory(database);

  final takePill = TakePill(
    batchFactory: batchFactory,
    batchSetPillSheetModifiedHistory: BatchSetPillSheetModifiedHistory(database),
    batchSetPillSheetGroup: BatchSetPillSheetGroup(database),
  );
  final updatedPillSheetGroup = await takePill(
    takenDate: takenDate,
    pillSheetGroup: pillSheetGroup,
    activePillSheet: activePillSheet,
    isQuickRecord: true,
  );

  // NOTE: iOSではAppDelegate.swiftの方で先にバッジのカウントはクリアしている
  FlutterAppBadger.removeBadge();

  // NOTE: Firebase initializeが成功しているかが定かでは無いので一番最後にログを送る
  analytics.logEvent(name: "interactive_widget_recorded");

  return updatedPillSheetGroup;
}
