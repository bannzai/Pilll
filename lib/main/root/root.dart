import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((app) {
      print("app name is $app.name");
      return FirebaseAuth.instance.signInAnonymously();
    }).then((userCredential) {
      return UserInterface.fetchOrCreateUser();
    }).then((user) {
      context.read<AuthUser>().user = user;
      if (user.setting == null || user.setting.firestoreRowData.isEmpty) {
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
      // TODO: DEBUG
      Navigator.popAndPushNamed(context, Routes.initialSetting);
      // Navigator.popAndPushNamed(context, Routes.main);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      body: Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(PilllColors.primary)),
        ),
      ),
    );
  }
}
