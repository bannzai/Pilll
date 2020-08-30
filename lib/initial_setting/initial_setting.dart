import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/immutable/user.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting_1.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Pilll/model/immutable/user.dart' as user;
import 'package:shared_preferences/shared_preferences.dart';

class InitialSettingModel {
  PillSheetType pillSheetType;
  int fromMenstruation;
  int durationMenstruation;
  int hour;
  int minute;
  bool isOnReminder;

  Future<void> register(
    BuildContext context,
  ) {
    return user.User.create().then((value) {
      value.setSettings({
        "beginingMenstruationFromAfterFakePeriod": fromMenstruation,
        "menstuationPeriod": durationMenstruation,
        "reminderTime": {"hour": hour, "minute": minute},
        "isOnReminder": isOnReminder,
        "pillSheetTypeRawPath": pillSheetType.name,
      }).then((_) {
        return SharedPreferences.getInstance();
      }).then((storage) {
        storage.setString(
            StringKey.firebaseAnonymousUserID, value.anonymousUserID);
      });
    });
  }
}

class InitialSetting extends StatelessWidget {
  const InitialSetting({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        backgroundColor: PilllColors.background,
        elevation: 0.0,
      ),
      body: Container(
        height: 445,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "ピルシートをご準備ください",
                style: FontType.title.merge(TextColorStyle.black),
              ),
              Text(
                "あなたの飲んでいるピルのタイプから\n使いはじめる準備をします",
                style: FontType.thinTitle.merge(TextColorStyle.gray),
              ),
              Image(
                image: AssetImage('images/initial_setting_pill_sheet.png'),
              ),
              RaisedButton(
                child: Text(
                  "OK",
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return InitialSetting1();
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
