import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/components/template/pill_sheet_type_setting/pill_sheet_type_select_body_template.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

class InitialSettingSelectPillSheetTypePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    if (state.isAccountCooperationDidEnd) {
      Future(() async {
        if (await store.canEndInitialSetting()) {
          AppRouter.signinAccount(context);
        }
        store.hideHUD();
      });
    }
    return HUD(
      shown: state.isLoading,
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          title: Text(
            "1/5",
            style: TextStyle(color: TextColor.black),
          ),
          backgroundColor: PilllColors.white,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 24),
                  Text("飲んでいるピルシートのタイプはどれ？",
                      style: FontType.sBigTitle.merge(TextColorStyle.main)),
                  SizedBox(height: 24),
                  PillSheetTypeSelectBodyTemplate(
                    onSelect: (type) {
                      analytics.logEvent(
                          name: "selected_type_initial_setting",
                          parameters: {"pill_sheet_type": type.rawPath});
                      store.selectedPillSheetType(type);
                    },
                    selectedPillSheetType: state.pillSheetTypes.isEmpty
                        ? null
                        : state.pillSheetTypes.first,
                  ),
                  SizedBox(height: 35),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 43),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state.pillSheetTypes.isNotEmpty)
                        PrimaryButton(
                          text: "次へ",
                          onPressed: () {
                            analytics.logEvent(
                                name: "next_initial_setting_pillsheet_type");
                            Navigator.of(context).push(
                                InitialSettingPillSheetCountPageRoute.route());
                          },
                        ),
                      if (!state.isAccountCooperationDidEnd) ...[
                        SizedBox(height: 20),
                        SecondaryButton(
                          text: "すでにアカウントをお持ちの方はこちら",
                          onPressed: () {
                            showSigninSheet(
                              context,
                              SigninSheetStateContext.initialSetting,
                              (accountType) async {
                                store.showHUD();
                                if (await store.canEndInitialSetting()) {
                                  AppRouter.signinAccount(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          "${accountType.providerName}でログインしました"),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension InitialSettingSelectPillSheetType
    on InitialSettingSelectPillSheetTypePage {
  static InitialSettingSelectPillSheetTypePage screen() {
    analytics.setCurrentScreen(
        screenName: "InitialSettingSelectPillSheetTypePage");
    return InitialSettingSelectPillSheetTypePage();
  }
}
