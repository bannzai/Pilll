import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/domain/initial_setting/initial_setting_select_today_pill_number.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class InitialSettingPillSheetCountPage extends HookWidget {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24),
              Text(
                "お手元のピルシートの枚数を\n選んでください",
                style: FontType.title.merge(TextColorStyle.main),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  children: state.pillSheetTypes
                      .asMap()
                      .map((index, pillSheetType) {
                        return MapEntry(
                          index,
                          [
                            InitialSettingPillSheetSelectRow(
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
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Switch(
                          value: state.isOnSequenceAppearance,
                          onChanged: (isOn) {
                            store.setIsOnSequenceAppearance(isOn);
                          }),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "連続服用する方は連番表示をお勧めします\n（ヤーズフレックスやジェミーナなど）",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 51),
              PrimaryButton(
                text: "次へ",
                onPressed: () async {
                  analytics.logEvent(name: "next_pill_sheet_count");
                  Navigator.of(context).push(
                      InitialSettingSelectTodayPillNumberPageRoute.route());
                },
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  // TODO:
  _onTapPanel(int count, InitialSettingStateStore store) {}
}

class InitialSettingPillSheetSelectRow extends StatelessWidget {
  const InitialSettingPillSheetSelectRow({
    Key? key,
    required this.index,
    required this.pillSheetType,
    required this.state,
    required this.store,
  }) : super(key: key);

  final int index;
  final PillSheetType pillSheetType;
  final InitialSettingState state;
  final InitialSettingStateStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}枚目",
            style: TextStyle(
              color: TextColor.main,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.japanese,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            constraints: BoxConstraints(minWidth: 297),
            color: PilllColors.white,
            child: Text(
              pillSheetType.fullName,
              style: TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension InitialSettingPillSheetCountPageRoute
    on InitialSettingPillSheetCountPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSettingPillSheetCountPage"),
      builder: (_) => InitialSettingPillSheetCountPage(),
    );
  }
}
