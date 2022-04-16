import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/service/local_notification.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pilll/util/datetime/day.dart';

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
      alert: true,
      badge: true,
      sound: true,
    );
  }
  listenNotificationEvents();

  final userService = UserService(DatabaseConnection(firebaseUser.uid));
  userService.fetch().then((_) async {
    final token = await FirebaseMessaging.instance.getToken();
    await userService.registerRemoteNotificationToken(token);
  });

  return Future.value();
}

void listenNotificationEvents() {
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    analytics.logEvent(name: "opened_from_notification_on_background");
    print("onMessageOpenedApp: $event");
  });
}
