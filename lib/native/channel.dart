import 'package:flutter/services.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        return recordPill();
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments);
      case "analytics":
        final arguments = call.arguments as Map<String, dynamic>;
        final name = arguments["name"] as String;
        final parameters = arguments["parameters"] as Map<String, dynamic>?;
        analytics.logEvent(name: name, parameters: parameters);
        break;
      default:
        break;
    }
  });
}
