import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/provider/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  debugPrint('[DEBUG] requestNotificationPermissions');
  if (Platform.isIOS) {
    try {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);
      await localNotificationService.requestiOSPermission();
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      // SimulatorではFCMトークンが取得できないため、デバッグモードでは取得しない。次のリンクのやり方を参考。https://github.com/firebase/flutterfire/issues/13575
      if (kDebugMode) {
        // デバッグモードではFCMトークンを'debug_mode'として登録する
        registerRemotePushNotificationToken(fcmToken: 'debug_mode', apnsToken: apnsToken);
      } else {
        // 本番モードではFCMトークンを取得する
        final fcmToken = await FirebaseMessaging.instance.getToken();
        registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: apnsToken);
      }
    } catch (e, stack) {
      // iOSの通知設定エラーはユーザーが対処できないため、Crashlyticsへの記録のみ行う
      debugPrint('[ERROR] requestNotificationPermissions: $e');
      errorLogger.recordError(e, stack);
    }
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
