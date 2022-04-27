import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/database/user.dart';
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
  listenNotificationEvents();

  final userDatastore = UserDatastore(DatabaseConnection(firebaseUser.uid));
  userDatastore.fetch().then((_) async {
    final token = await FirebaseMessaging.instance.getToken();
    await userDatastore.registerRemoteNotificationToken(token);
  });
  return Future.value();
}

void listenNotificationEvents() {
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    analytics.logEvent(name: "opened_from_notification_on_background");
    debugPrint("onMessageOpenedApp: $event");
  });
}
