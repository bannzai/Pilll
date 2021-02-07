import 'dart:io';

import 'package:Pilll/auth/auth.dart';
import 'package:Pilll/database/database.dart';
import 'package:Pilll/service/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermissions() async {
  await FirebaseMessaging().requestNotificationPermissions();
  callRegisterRemoteNotification();
  auth().then((auth) {
    final userService = UserService(DatabaseConnection(auth.uid));
    userService.fetch().then((_) async {
      final token = await FirebaseMessaging().getToken();
      await userService.registerRemoteNotificationToken(token);
    });
  });
  return Future.value();
}

void listenNotificationEvents() {
  FirebaseMessaging()
    ..configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onBackgroundMessage: Platform.isAndroid ? onBackgroundMessage : null,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
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
