import 'package:flutter/services.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/provider/database.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
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
