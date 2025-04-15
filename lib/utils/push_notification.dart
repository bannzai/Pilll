import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/provider/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyEmergencyAlertEnabled = 'emergency_alert_enabled';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);
    await localNotificationService.requestPermission();
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: apnsToken);
  }

  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: null);

    await AndroidFlutterLocalNotificationsPlugin().requestNotificationsPermission();
    await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
  }
}
