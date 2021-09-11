import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/settin_pill_sheet_group.dart';
import 'package:pilll/domain/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitialSettingPillSheetGroupPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "2/5",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            children: [
              SettingPillSheetGroup(
                pillSheetTypes: state.pillSheetTypes,
                onAdd: (pillSheetType) => store.addPillSheetType(pillSheetType),
                onChange: (index, pillSheetType) =>
                    store.changePillSheetType(index, pillSheetType),
                onDelete: (index) => store.removePillSheetType(index),
                isOnSequenceAppearance: state.isOnSequenceAppearance,
                setIsOnSequenceAppearance: (isOn) =>
                    store.setIsOnSequenceAppearance(isOn),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Container(
                    color: PilllColors.background,
                    child: PrimaryButton(
                      text: "次へ",
                      onPressed: () async {
                        analytics.logEvent(name: "next_pill_sheet_count");
                        Navigator.of(context).push(
                            InitialSettingSelectTodayPillNumberPageRoute
                                .route());
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
