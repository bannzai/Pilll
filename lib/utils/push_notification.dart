import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/provider/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyEmergencyAlertEnabled = 'emergency_alert_enabled';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  // 緊急アラート設定を確認
  final prefs = await SharedPreferences.getInstance();
  final isEmergencyAlertEnabled = prefs.getBool(_keyEmergencyAlertEnabled) ?? false;

  // 緊急アラートが有効の場合はcriticalAlertも要求
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: true,
    criticalAlert: isEmergencyAlertEnabled, // 緊急アラートが有効な場合のみ要求
  );

  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  final fcmToken = await FirebaseMessaging.instance.getToken();

  registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: apnsToken);

  if (Platform.isAndroid) {
    await AndroidFlutterLocalNotificationsPlugin().requestNotificationsPermission();
    await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
  }
}
