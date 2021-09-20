import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/domain/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:pilll/entity/link_account_type.dart';

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
          "1/4",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "処方されるピルについて\n教えてください",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    SettingPillSheetGroup(
                      pillSheetTypes: state.pillSheetTypes,
                      onAdd: (pillSheetType) =>
                          store.addPillSheetType(pillSheetType),
                      onChange: (index, pillSheetType) =>
                          store.changePillSheetType(index, pillSheetType),
                      onDelete: (index) => store.removePillSheetType(index),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Container(
                    color: PilllColors.background,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PrimaryButton(
                          text: "次へ",
                          onPressed: () async {
                            analytics.logEvent(name: "next_pill_sheet_count");
                            Navigator.of(context).push(
                                InitialSettingSelectTodayPillNumberPageRoute
                                    .route());
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
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
