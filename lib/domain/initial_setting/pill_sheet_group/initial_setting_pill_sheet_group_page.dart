import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/pill_sheet_type_add_button.dart';
import 'package:pilll/domain/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_pill_sheet_type_select_row.dart';

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
              ListView(
                children: [
                  SizedBox(height: 24),
                  Text(
                    "お手元のピルシートの枚数を\n選んでください",
                    style: FontType.title.merge(TextColorStyle.main),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  ...state.pillSheetTypes
                      .asMap()
                      .map((index, pillSheetType) {
                        return MapEntry(
                          index,
                          [
                            SizedBox(height: 16),
                            InitialSettingPillSheetGroupPillSheetTypeSelectRow(
                              index: index,
                              pillSheetType: pillSheetType,
                              state: state,
                              store: store,
                            ),
                          ],
                        );
                      })
                      .values
                      .expand((element) => element)
                      .toList(),
                  if (state.pillSheetTypes.length > 1) ...[
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                "連番表示モード",
                                style: TextStyle(
                                  color: TextColor.main,
                                  fontSize: 14,
                                  fontFamily: FontFamily.japanese,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 8),
                              SvgPicture.asset("images/help.svg")
                            ],
                          ),
                        ),
                        Spacer(),
                        Switch(
                            value: state.isOnSequenceAppearance,
                            onChanged: (isOn) {
                              store.setIsOnSequenceAppearance(isOn);
                            }),
                      ],
                    ),
                  ],
                  SizedBox(height: 24),
                  PillSheetTypeAddButton(store: store),
                  SizedBox(height: 80),
                ],
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
