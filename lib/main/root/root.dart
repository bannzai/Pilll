import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/main/components/indicator.dart';
import 'package:Pilll/service/user.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(initialUserProvider.future).then((user) {
      if (user.setting == null) {
        Navigator.popAndPushNamed(context, Routes.initialSetting);
        return null;
      }
      return SharedPreferences.getInstance().then((storage) {
        if (!storage.getKeys().contains(StringKey.firebaseAnonymousUserID)) {
          storage.setString(
              StringKey.firebaseAnonymousUserID, user.anonymousUserID);
        }
        return storage;
      });
    }).then((storage) {
      if (storage == null) {
        return;
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
    });

    return Scaffold(
      backgroundColor: PilllColors.background,
      body: Indicator(),
    );
  }
}
