import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/initial_setting_menstruation.dart';
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InitialSettingPillSheetCountPanel(
                          number: 0,
                          state: state,
                          onTap: (number) => _onTapPanel(number, store),
                        ),
                        InitialSettingPillSheetCountPanel(
                          number: 1,
                          state: state,
                          onTap: (number) => _onTapPanel(number, store),
                        ),
                        InitialSettingPillSheetCountPanel(
                          number: 2,
                          state: state,
                          onTap: (number) => _onTapPanel(number, store),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InitialSettingPillSheetCountPanel(
                          number: 3,
                          state: state,
                          onTap: (number) => _onTapPanel(number, store),
                        ),
                        InitialSettingPillSheetCountPanel(
                          number: 4,
                          state: state,
                          onTap: (number) => _onTapPanel(number, store),
                        ),
                        InitialSettingPillSheetCountPanel(
                          number: 5,
                          state: state,
                          onTap: (number) => _onTapPanel(number, store),
                        ),
                      ],
                    ),
                  ],
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
                  if (state.pillSheetCount == 0) {
                    Navigator.of(context)
                        .push(InitialSettingMenstruationPageRoute.route());
                  } else {
                    Navigator.of(context).push(
                        InitialSettingSelectTodayPillNumberPageRoute.route());
                  }
                },
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  _onTapPanel(int count, InitialSettingStateStore store) {
    store.selectedPillSheetCount(count);
  }
}

class InitialSettingPillSheetCountPanel extends StatelessWidget {
  const InitialSettingPillSheetCountPanel({
    Key? key,
    required this.number,
    required this.state,
    required this.onTap,
  }) : super(key: key);

  final int number;
  final InitialSettingState state;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(number),
      child: Container(
        width: 97,
        height: 68,
        decoration: BoxDecoration(
          color: state.pillSheetCount == number
              ? PilllColors.secondary
              : PilllColors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 2, color: PilllColors.secondary),
        ),
        child: Center(
          child: Text(
            "$number",
            style: TextStyle(
              color: state.pillSheetCount == number
                  ? TextColor.white
                  : TextColor.main,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.number,
            ),
          ),
        ),
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
