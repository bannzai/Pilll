import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/record/util/take.dart';
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
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    return;
  }

  final database = DatabaseConnection(firebaseUser.uid);
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

  final takenDate = now();
  final batchFactory = BatchFactory(database);
  await take(
    takenDate: takenDate,
    pillSheetGroup: pillSheetGroup,
    activedPillSheet: activedPillSheet,
    batchFactory: batchFactory,
    pillSheetService: pillSheetService,
    pillSheetModifiedHistoryService: pillSheetModifiedHistoryService,
    pillSheetGroupService: pillSheetGroupService,
  );

  FlutterAppBadger.removeBadge();
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
