import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/provider/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pilll/utils/local_notification.dart';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  debugPrint('[DEBUG] requestNotificationPermissions');
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);
    await localNotificationService.requestiOSPermission();
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: apnsToken);
  }

  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);

    final fcmToken = await FirebaseMessaging.instance.getToken();
    registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: null);

    final androidNotificationGranded = await AndroidFlutterLocalNotificationsPlugin().requestNotificationsPermission();
    if (androidNotificationGranded != true) {
      throw Exception('通知権限が許可されていません。設定から許可してください。');
    }

    final granted = await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
    if (granted != true) {
      throw Exception('正確なアラーム権限が許可されていません。設定から許可してください。');
    }
  }
}
