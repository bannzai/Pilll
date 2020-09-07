import 'package:Pilll/initial_setting/initial_setting_2.dart';
import 'package:Pilll/main/components/pill_sheet_type_select_page.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:Pilll/model/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSetting1 extends StatefulWidget {
  const InitialSetting1({Key key}) : super(key: key);

  @override
  _InitialSetting1State createState() => _InitialSetting1State();
}

class _InitialSetting1State extends State<InitialSetting1> {
  @override
  Widget build(BuildContext context) {
    Setting model = Provider.of<AuthUser>(context).user.setting;
    return PillSheetTypeSelectPage(
      title: "1/4",
      callback: (type) {
        setState(() {
          model.pillSheetType = type;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return InitialSetting2();
          }));
        });
      },
      selectedPillSheetType: model.pillSheetType,
    );
  }
}
