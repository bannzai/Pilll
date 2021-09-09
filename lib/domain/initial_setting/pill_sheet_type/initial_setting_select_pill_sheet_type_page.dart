import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_select_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/link_account_type.dart';

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
      child: PillSheetTypeSelectPageLayout(
        title: "1/5",
        backButtonIsHidden: true,
        selected: (type) {
          analytics.logEvent(
              name: "selected_type_initial_setting",
              parameters: {"pill_sheet_type": type.rawPath});
          store.selectedPillSheetType(type);
        },
        done: state.pillSheetTypes.isEmpty
            ? null
            : () {
                analytics.logEvent(name: "next_initial_setting_pillsheet_type");
                Navigator.of(context)
                    .push(InitialSettingPillSheetCountPageRoute.route());
              },
        doneButtonText: "次へ",
        selectedPillSheetType:
            state.pillSheetTypes.isEmpty ? null : state.pillSheetTypes.first,
        signinAccount: state.isAccountCooperationDidEnd
            ? null
            : (accountType) async {
                store.showHUD();
                if (await store.canEndInitialSetting()) {
                  AppRouter.signinAccount(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("${accountType.providerName}でログインしました"),
                    ),
                  );
                }
              },
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
