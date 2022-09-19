import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        final pillSheetGroup = await recordPill();
        syncActivePillSheetValue(pillSheetGroup: pillSheetGroup);
        return;
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments);
      case "analytics":
        final name = call.arguments["name"] as String;
        final parameters = Map<String, dynamic>.from(call.arguments["parameters"]);
        analytics.logEvent(name: name, parameters: parameters);
        break;
      default:
        break;
    }
  });
}
