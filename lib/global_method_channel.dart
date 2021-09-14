import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/service/auth.dart';

final _channel = MethodChannel("method.channel.MizukiOhashi.Pilll");
definedChannel() {
  _channel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        return recordPill();
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments)
            .catchError((error) => print(error));
      default:
        break;
    }
  });
}

Future<void> recordPill() async {
  final authInfo = await cacheOrAuth();
  final database = DatabaseConnection(authInfo.uid);
  final pillSheetService = PillSheetService(database);
  final pillSheetModifiedHistoryService =
      PillSheetModifiedHistoryService(database);
  final pillSheetGroupService = PillSheetGroupService(database);
  final pillSheetGroup = await pillSheetGroupService.fetchLatest();
  if (pillSheetGroup == null) {
    return Future.value();
  }
  final activedPillSheet = pillSheetGroup.activedPillSheet;
  if (activedPillSheet == null) {
    return Future.value();
  }

  final batch = database.batch();

  final n = now();
  final List<PillSheet> updatedPillSheets = pillSheetGroup.pillSheets;
  pillSheetGroup.pillSheets.asMap().keys.forEach((index) {
    final pillSheet = pillSheetGroup.pillSheets[index];
    if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
      return;
    }
    var filledDuration = n.difference(pillSheet.beginingDate).inDays;
    if (filledDuration > pillSheet.pillSheetType.totalCount) {
      filledDuration = pillSheet.pillSheetType.totalCount;
    }
    final scheduledLastTakenDate =
        pillSheet.beginingDate.add(Duration(days: filledDuration));
    final updatedPillSheet =
        pillSheet.copyWith(lastTakenDate: scheduledLastTakenDate);
    pillSheetService.update(batch, updatedPillSheet);
    updatedPillSheets[index] = updatedPillSheet;

    final history =
        PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            before: activedPillSheet, after: updatedPillSheet);
    pillSheetModifiedHistoryService.add(batch, history);
  });

  final updatedPillSheetGroup =
      pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
  pillSheetGroupService.update(batch, updatedPillSheetGroup);

  await batch.commit();
  // NOTE: Firebase initializeが成功しているかが定かでは無いので一番最後にログを送る
  analytics.logEvent(name: "quick_recorded");
}

Future<void> salvagedOldStartTakenDate(dynamic arguments) async {
  if (arguments == null) {
    return Future.value();
  }
  final dic = arguments as Map<dynamic, dynamic>?;
  if (dic == null) {
    return Future.value();
  }

  Map<String, String> typedDic;
  try {
    typedDic = dic.cast<String, String>();
  } catch (error) {
    return Future.value();
  }

  final salvagedOldStartTakenDateRawValue =
      typedDic["salvagedOldStartTakenDate"];
  if (salvagedOldStartTakenDateRawValue == null) {
    return Future.value();
  }
  if (!salvagedOldStartTakenDateRawValue.contains("/")) {
    return Future.value();
  }
  final salvagedOldLastTakenDateRawValue = typedDic["salvagedOldLastTakenDate"];
  if (salvagedOldLastTakenDateRawValue == null) {
    return Future.value();
  }
  if (!salvagedOldLastTakenDateRawValue.contains("/")) {
    return Future.value();
  }
  final formattedStartTakenDate =
      salvagedOldStartTakenDateRawValue.replaceAll("/", "-");
  final formattedSalvagedOldLastTakenDate =
      salvagedOldLastTakenDateRawValue.replaceAll("/", "-");
  return SharedPreferences.getInstance().then((storage) {
    storage.setString("salvagedOldStartTakenDate", formattedStartTakenDate);
    storage.setString(
        "salvagedOldLastTakenDate", formattedSalvagedOldLastTakenDate);
  });
}
