import 'dart:io';

import 'package:pilll/analytics.dart';
import 'package:pilll/auth/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/service/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermissions() async {
  await FirebaseMessaging.instance.requestPermission();
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
  callRegisterRemoteNotification();
  auth().then((auth) {
    final userService = UserService(DatabaseConnection(auth.uid));
    userService.fetch().then((_) async {
      final token = await FirebaseMessaging.instance.getToken();
      await userService.registerRemoteNotificationToken(token);
    });
  });
  return Future.value();
}

void listenNotificationEvents() {
  FirebaseMessaging.onMessage.listen((event) {
    print('onMessage: $event');
  });
  if (Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(
        (message) => onBackgroundMessage(message.data));
  }
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    analytics.logEvent(name: "opened_from_notification_on_background");
    print("onMessageOpenedApp: $event");
  });
}

void callRegisterRemoteNotification() {
  if (Platform.isIOS) {
    // NOTE: FirebaseMessaging.configure call [UIApplication registerForRemoteNotifcation] from native library.
    // Reason for calling listenNotificationEvents, I won't overwrite defined to receive event via FirebaseMessaging().configure.
    listenNotificationEvents();
  }
}

Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // データメッセージをハンドリング
    final data = message['data'];
    print("data: $data");
  }

  if (message.containsKey('notification')) {
    // 通知メッセージをハンドリング
    final notification = message['notification'];
    print("notification: $notification");
  }
  print('onBackground: $message');
}
