import 'package:flutter/services.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';

final methodChannel = const MethodChannel("method.channel.MizukiOhashi.Pilll");
definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        await recordPill();
        return;
      case "salvagedOldStartTakenDate":
        try {
          await salvagedOldStartTakenDate(call.arguments);
        } catch (error, stack) {
          errorLogger.recordError(error, stack);
          print(error);
        }
        return;
      default:
        break;
    }
  });
}
