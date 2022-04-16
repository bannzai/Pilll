import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final title = message.data["title"];
  final body = message.data["body"];
  final notificationType = message.data["notificationType"];
  if (title == null || body == null || notificationType == null) {
    return;
  }

  switch (notificationType) {
    case "CREATE_NEW_PILL_SHEET":
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        return;
      }

      final database = DatabaseConnection(firebaseUser.uid);
      final userService = UserService(database);
      final pillSheetGroupService = PillSheetGroupService(database);

      final user = await userService.fetch();
      final setting = user.setting;
      final pillSheetGroup = await pillSheetGroupService.fetchLatest();
      final activedPillSheet = pillSheetGroup?.activedPillSheet;
      if (pillSheetGroup == null ||
          activedPillSheet == null ||
          setting == null) {
        return;
      }

      final isTrialOrPremium = user.isTrial || user.isPremium;
      await localNotification.scheduleRemiderNotification(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
        isTrialOrPremium: isTrialOrPremium,
        setting: setting,
        tzFrom: now().tzDate(),
      );

      localNotification.fireCreateNewPillSheetNotification(
        title: title,
        body: body,
      );
      break;
    default:
      return;
  }
}
