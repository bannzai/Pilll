import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/initial_setting/initial_setting_select_today_pill_number.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/store/initial_setting.dart';
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
      child: PillSheetTypeSelectPage(
        title: "1/4",
        backButtonIsHidden: true,
        selected: (type) {
          analytics.logEvent(
              name: "selected_type_initial_setting_1",
              parameters: {"pill_sheet_type": type.rawPath});
          store.selectedPillSheetType(type);
        },
        done: state.entity.pillSheetType == null
            ? null
            : () {
                analytics.logEvent(name: "done_initial_setting_1");
                Navigator.of(context)
                    .push(InitialSettingSelectTodayPillNumberPageRoute.route());
              },
        doneButtonText: "次へ",
        selectedPillSheetType: state.entity.pillSheetType,
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
