import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((storage) {
      if (storage.getBool(BoolKey.didEndInitialSetting)) {
        Navigator.popAndPushNamed(context, Routes.main);
      } else {
        Navigator.popAndPushNamed(context, Routes.initialSetting);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement
    return Container();
  }
}
