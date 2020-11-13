import 'package:Pilll/router/router.dart';
import 'package:Pilll/components/molecules/indicator.dart';
import 'package:Pilll/entity/user.dart';
import 'package:Pilll/service/push_notification.dart';
import 'package:Pilll/service/user.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RootState { notYetLoad, loading, loaded }

class RootStore extends StateNotifier<RootState> {
  final UserServiceInterface userService;
  RootStore(this.userService) : super(RootState.notYetLoad);

  Future<User> initialize() {
    return initNotification()
        .then(
          (_) => userService.prepare(),
        )
        .then(
          (user) => firebaseMessaging
              .getToken()
              .then(
                (token) => userService.registerRemoteNotificationToken(token),
              )
              .then(
                (_) => userService.prepare(),
              ),
        );
  }
}

final rootStoreProvider =
    StateNotifierProvider((ref) => RootStore(ref.watch(userServiceProvider)));
final initializeProvider =
    FutureProvider((ref) => ref.watch(rootStoreProvider).initialize());

class Root extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return useProvider(initializeProvider).when(data: (user) {
      print("when success: $user");
      _transition(context, user);
      return Container();
    }, loading: () {
      print("loading ... ");
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

  void _transition(BuildContext context, User user) {
    Future(() async {
      if (user.setting == null) {
        Navigator.popAndPushNamed(context, Routes.initialSetting);
        return Container();
      }
      SharedPreferences.getInstance().then((storage) {
        if (!storage.getKeys().contains(StringKey.firebaseAnonymousUserID)) {
          storage.setString(
              StringKey.firebaseAnonymousUserID, user.anonymouseUserID);
        }
        return storage;
      }).then((storage) {
        if (storage == null) {
          return;
        }
        bool didEndInitialSetting =
            storage.getBool(BoolKey.didEndInitialSetting);
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
      });
    });
  }
}
