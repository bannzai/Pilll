import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pilll/native/channel.dart';

// NOTE: [SyncData:Widget]
Future<void> syncActivePillSheetValue({
  required PillSheetGroup? pillSheetGroup,
}) async {
  try {
    final map = {
      'pillSheetLastTakenDate': pillSheetGroup?.activePillSheet?.lastTakenDate?.millisecondsSinceEpoch,
      'pillSheetTodayPillNumber': pillSheetGroup?.activePillSheet?.todayPillNumber,
      'pillSheetGroupTodayPillNumber': pillSheetGroup?.sequentialTodayPillNumber,
      'pillSheetEndDisplayPillNumber': pillSheetGroup?.displayNumberSetting?.endPillNumber,
      'pillSheetValueLastUpdateDateTime': DateTime.now().millisecondsSinceEpoch,
      // NOTE: 昔はSetting.pillSheetAppearanceModeがWidgetに同期されていたが、PillSheetGroupに移行したため、PillSheetGroupのものを使用する。気が向いたらkeyもリネームする
      'settingPillSheetAppearanceMode': pillSheetGroup?.pillSheetAppearanceMode.name,
      // NOTE: settingPillSheetAppearanceMode から移行中。強制アップデートが浸透してから削除する。 since: 2025-05-25
      'pillSheetGroupPillSheetAppearanceMode': pillSheetGroup?.pillSheetAppearanceMode.name,
    };
    for (final element in map.entries) {
      await HomeWidget.saveWidgetData(element.key, element.value);
    }
    await updateWidget();
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<void> syncUserStatus({required User? user}) async {
  try {
    await HomeWidget.saveWidgetData(
      'userIsPremiumOrTrial',
      user?.premiumOrTrial,
    );
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
    qualifiedAndroidName: 'com.mizuki.Ohashi.Pilll.PilllAppWidget',
  );

  // QuickRecordの際にWidgetがリロードされない。上述のHomeWidget.updateWidgetでも通常の服用記録からの更新はうまくいくため、
  // 何か難しい問題を孕んでいると予想。.swiftのコードをmethodChannelから呼び出せばリロードされるのでとりあえずそっちも呼ぶ
  if (Platform.isIOS) {
    await methodChannel.invokeMethod('reloadWidget');
  }
}
