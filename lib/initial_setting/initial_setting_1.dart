import 'package:Pilll/initial_setting/initial_setting_2.dart';
import 'package:Pilll/main/components/pill_sheet_type_select_page.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InitialSetting1 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = userProvider();
    return PillSheetTypeSelectPage(
      title: "1/4",
      callback: (type) {
        setState(() {
          state.initialSetting.pillSheetType = type;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return InitialSetting2();
          }));
        });
      },
      selectedPillSheetType:
          AppState.watch(context).initialSetting.pillSheetType,
    );
  }
}
