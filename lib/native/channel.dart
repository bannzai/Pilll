import 'package:flutter/services.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        final pillSheetGroup = await recordPill();
        syncActivePillSheetValue(activePillSheet: pillSheetGroup?.activedPillSheet, userIsPremiumOrTrial: true);
        return;
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments);
      default:
        break;
    }
  });
}
