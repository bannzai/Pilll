import 'package:Pilll/auth/auth.dart';
import 'package:Pilll/database/database.dart';
import 'package:Pilll/router/router.dart';
import 'package:Pilll/components/molecules/indicator.dart';
import 'package:Pilll/entity/user.dart';
import 'package:Pilll/service/push_notification.dart';
import 'package:Pilll/service/user.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends HookWidget {
  @override
  Widget build(BuildContext context) {
    listenNotificationEvents();
    return useProvider(authStateChangesProvider).when(data: (authInfo) {
      print("when success: ${authInfo.uid}");
      final userService = UserService(DatabaseConnection(authInfo.uid));
      userService.prepare().then((_) {
        return FirebaseMessaging()
            .getToken()
            .then(
              (token) => userService.registerRemoteNotificationToken(token),
            )
            .then(
              (_) => userService.fetch(),
            )
            .then((user) {
          userService.saveLaunchInfo();
          _transition(context, user, userService);
        });
      });
      return Scaffold(
        backgroundColor: PilllColors.background,
        body: Indicator(),
      );
    }, loading: () {
      print("loading ... ");
      auth();
      return Scaffold(
        backgroundColor: PilllColors.background,
        body: Indicator(),
      );
    }, error: (err, stack) {
      print("err: $err");
      return Scaffold(
        backgroundColor: PilllColors.background,
        body: Indicator(),
      );
    });
  }

  void _transition(
      BuildContext context, User user, UserServiceInterface service) async {
    if (!user.migratedFlutter) {
      service
          .deleteSettings()
          .then((_) => service.setFlutterMigrationFlag())
          .then(
              (_) => Navigator.popAndPushNamed(context, Routes.initialSetting));
      return;
    }
    final storage = await SharedPreferences.getInstance();
    if (!storage.getKeys().contains(StringKey.firebaseAnonymousUserID)) {
      storage.setString(
          StringKey.firebaseAnonymousUserID, user.anonymouseUserID);
    }
    bool didEndInitialSetting = storage.getBool(BoolKey.didEndInitialSetting);
    if (didEndInitialSetting == null) {
      Navigator.popAndPushNamed(context, Routes.initialSetting);
      return;
    }
    if (!didEndInitialSetting) {
      Navigator.popAndPushNamed(context, Routes.initialSetting);
      return;
    }
    Navigator.popAndPushNamed(context, Routes.main);
    // Navigator.popAndPushNamed(context, Routes.initialSetting);
  }
}
