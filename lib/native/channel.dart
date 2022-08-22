import 'package:flutter/services.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        await recordPill();
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments);
      default:
        break;
    }
  });
}
