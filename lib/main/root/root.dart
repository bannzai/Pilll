import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:provider/provider.dart';
import 'package:Pilll/model/immutable/user.dart' as user;

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
      context.read<AuthUser>().userCredential = userCredential;
      return user.UserInterface.fetchOrCreateUser();
    }).then((user) {
      if (user.settings == null || user.settings.isEmpty) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text('Pilll'),
        backgroundColor: PilllColors.primary,
      ),
      body: Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(PilllColors.primary)),
        ),
      ),
    );
  }
}
