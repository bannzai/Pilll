import 'package:Pilll/database/database.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth.dart';

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
  final authInfo = await auth();
  final service = PillSheetService(DatabaseConnection(authInfo.uid));
  final entity = await service.fetchLast();
  await service.update(entity.copyWith(lastTakenDate: now()));
}

Future<void> salvagedOldStartTakenDate(dynamic arguments) async {
  if (arguments == null) {
    return Future.value();
  }
  final dic = arguments as Map<dynamic, dynamic>;
  if (dic == null) {
    return Future.value();
  }
  final typedDic = dic.cast<String, String>();
  if (typedDic == null) {
    return Future.value();
  }
  final rawValue = typedDic["salvagedOldStartTakenDate"];
  if (rawValue == null) {
    return Future.value();
  }
  if (!rawValue.contains("/")) {
    return Future.value();
  }
  final formatted = rawValue.replaceAll("/", "-");
  return SharedPreferences.getInstance().then((storage) {
    storage.setString("salvagedOldStartTakenDate", formatted);
  });
}
