import 'package:Pilll/database/database.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:flutter/services.dart';

import 'auth/auth.dart';

final _channel = MethodChannel("method.channel.MizukiOhashi.Pilll");
definedChannel() {
  _channel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        return recordPill();
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
