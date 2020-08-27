import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // TODO: Handling error
      assert(e);
    }
  }

  @override
  void initState() {
    initializeFirebase();
    super.initState();
    SharedPreferences.getInstance().then((storage) {
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
      body: Container(),
    );
  }
}
