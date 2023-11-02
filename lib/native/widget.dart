import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/native/channel.dart';

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
Future<void> handleInteractiveWidgetTakenPill() async {}
