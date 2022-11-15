import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  await FirebaseMessaging.instance.requestPermission();
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }
  listenNotificationEvents();
  registerRemotePushNotificationToken(await FirebaseMessaging.instance.getToken());
}

void listenNotificationEvents() {
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    analytics.logEvent(name: "opened_from_notification_on_background");
    debugPrint("onMessageOpenedApp: $event");
  });
}
