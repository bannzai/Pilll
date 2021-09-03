import 'package:pilll/analytics.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/store/initial_setting.dart';
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
                child: Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 97 / 68,
                    children: List.generate(5, (index) {
                      final number = index + 1;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              width: 2, color: PilllColors.secondary),
                        ),
                        child: Center(
                          child: Text(
                            "$number",
                            style: TextStyle(
                              color: TextColor.main,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontFamily.number,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 62),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "連続服用タイプ",
                        style: TextStyle(
                          color: TextColor.main,
                          fontSize: 14,
                          fontFamily: FontFamily.japanese,
                        ),
                      ),
                      Switch(value: true, onChanged: (isOn) {}),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "ヤーズフレックス等で連続服用する方は\nオンにしてください",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Spacer(),
              PrimaryButton(
                text: "次へ",
                onPressed: () {
                  analytics.logEvent(name: "done_initial_setting_4");
                  store
                      .register(state.entity.copyWith(isOnReminder: true))
                      .then((_) => AppRouter.endInitialSetting(context));
                },
              ),
              SizedBox(height: 35),
            ],
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
