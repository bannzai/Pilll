import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/service/local_notification.dart';
import 'package:pilll/service/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermissions() async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    assert(false);
    return;
  }

  await FirebaseMessaging.instance.requestPermission();
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
  callRegisterRemoteNotification();

  final userService = UserService(DatabaseConnection(firebaseUser.uid));
  userService.fetch().then((_) async {
    final token = await FirebaseMessaging.instance.getToken();
    await userService.registerRemoteNotificationToken(token);
  });
  return Future.value();
}

void listenNotificationEvents() {
  FirebaseMessaging.onMessage.listen((event) {
    print('onMessage: $event');
  });
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
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
  await localNotification.test();
}
