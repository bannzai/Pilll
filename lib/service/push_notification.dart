import 'dart:async';
import 'dart:io';

import 'package:pilll/analytics.dart';
import 'package:pilll/service/auth.dart';
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
  // ignore: unawaited_futures
  cacheOrAuth().then((auth) {
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
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
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

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print("Handling a background message ${message.data}");
  final messageData = message.data;
  if (messageData.containsKey('data')) {
    // データメッセージをハンドリング
    final data = messageData['data'];
    print("data: $data");
  }

  if (messageData.containsKey('notification')) {
    // 通知メッセージをハンドリング
    final notification = messageData['notification'];
    print("notification: $notification");
  }
  print('onBackground: $message');
}
