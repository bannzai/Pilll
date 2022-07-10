import 'package:flutter/services.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';

final methodChannel = const MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        return recordPill();
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments);
      default:
        break;
    }
  });
}
