import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/native/channel.dart';
import 'package:home_widget/home_widget.dart';

Future<void> syncActivePillSheetValue({
  required PillSheetGroup? pillSheetGroup,
}) async {
  try {
    final map = {
      "pillSheetLastTakenDate": pillSheetGroup?.activePillSheet?.lastTakenDate?.millisecondsSinceEpoch,
      "pillSheetTodayPillNumber": pillSheetGroup?.activePillSheet?.todayPillNumber,
      "pillSheetGroupTodayPillNumber": pillSheetGroup?.sequentialTodayPillNumber,
      "pillSheetEndDisplayPillNumber": pillSheetGroup?.displayNumberSetting?.endPillNumber,
      "pillSheetValueLastUpdateDateTime": DateTime.now().millisecondsSinceEpoch,
    };
    for (final element in map.entries) {
      await HomeWidget.saveWidgetData(element.key, element.value);
    }
    await updateWidget();
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<void> syncSetting({
  required Setting? setting,
}) async {
  try {
    await HomeWidget.saveWidgetData("settingPillSheetAppearanceMode", setting?.pillSheetAppearanceMode.name);
    await updateWidget();
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<void> syncUserStatus({
  required User? user,
}) async {
  try {
    await HomeWidget.saveWidgetData("userIsPremiumOrTrial", user?.premiumOrTrial);
    await updateWidget();
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<void> updateWidget() async {
  await HomeWidget.updateWidget(
    name: 'PilllAppWidget',
    androidName: 'PilllAppWidget',
    iOSName: 'com.mizuki.Ohashi.Pilll.widget',
  );
}
