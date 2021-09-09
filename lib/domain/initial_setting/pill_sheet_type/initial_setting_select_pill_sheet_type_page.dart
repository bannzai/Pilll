import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/components/template/setting_pill_sheet_type/pill_sheet_type_select_page_template.dart';
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
      child: PillSheetTypeSelectPageTemplate(
        title: "1/5",
        backButtonIsHidden: true,
        onSelect: (type) {
          analytics.logEvent(
              name: "selected_type_initial_setting",
              parameters: {"pill_sheet_type": type.rawPath});
          store.selectedPillSheetType(type);
        },
        doneButton: state.pillSheetTypes.isEmpty
            ? null
            : PrimaryButton(
                text: "次へ",
                onPressed: () {
                  analytics.logEvent(
                      name: "next_initial_setting_pillsheet_type");
                  Navigator.of(context)
                      .push(InitialSettingPillSheetCountPageRoute.route());
                }),
        selectedPillSheetType:
            state.pillSheetTypes.isEmpty ? null : state.pillSheetTypes.first,
        signinButton: state.isAccountCooperationDidEnd
            ? null
            : SecondaryButton(
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
                            content:
                                Text("${accountType.providerName}でログインしました"),
                          ),
                        );
                      }
                    },
                  );
                },
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
