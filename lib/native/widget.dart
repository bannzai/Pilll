import 'package:flutter/material.dart';
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

@pragma('vm:entry-point')
Future<void> handleInteractiveWidgetTakenPill() async {}
