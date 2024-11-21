import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/provider/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }
  await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);
  registerRemotePushNotificationToken(await FirebaseMessaging.instance.getToken());

  if (Platform.isAndroid) {
    await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
  }
}
