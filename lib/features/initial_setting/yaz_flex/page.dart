import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/page.dart';
import 'package:pilll/features/initial_setting/today_pill_number/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';
import 'package:pilll/utils/analytics.dart';

/// 初期設定の最初のページ。「ヤーズフレックスの方ですか？」を尋ね、
/// 「はい」はヤーズフレックス向けの導線 (今日飲む番号 → 前回の休薬・開始番号)、「いいえ」は従来の導線 (ピルシートの種類) へ進む
class InitialSettingYazFlexPage extends ConsumerWidget {
  const InitialSettingYazFlexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);

    return HUD(
      shown: state.isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.white),
        body: SafeArea(
          child: Container(
            // Column は子の最大幅に縮むため、説明文が短いと左に寄る。画面幅いっぱいにして中央に揃える
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  L.initialSettingAskYazFlex,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: TextColor.main,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  L.initialSettingAskYazFlexDescription,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: PrimaryButton(
                    text: L.yes,
                    onPressed: () async {
                      analytics.logEvent(name: 'initial_setting_yaz_flex_yes');
                      store.selectYazFlex();
                      Navigator.of(context).push(
                        InitialSettingSelectTodayPillNumberPageRoute.route(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 180,
                  child: AppOutlinedButton(
                    text: L.no,
                    onPressed: () async {
                      analytics.logEvent(name: 'initial_setting_yaz_flex_no');
                      store.selectNotYazFlex();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: const RouteSettings(
                            name: 'InitialSettingPillSheetGroupPage',
                          ),
                          builder: (_) => InitialSettingPillSheetGroupPageRoute.screen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                AlertButton(
                  text: L.existingAccountUsers,
                  onPressed: () async {
                    analytics.logEvent(
                      name: 'pressed_initial_setting_yaz_flex_signin',
                    );
                    showSignInSheet(
                      context,
                      SignInSheetStateContext.initialSetting,
                      (accountType) async {
                        store.showHUD();
                      },
                    );
                  },
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension InitialSettingYazFlexPageRoute on InitialSettingYazFlexPage {
  static InitialSettingYazFlexPage screen() {
    analytics.logScreenView(screenName: 'InitialSettingYazFlexPage');
    return const InitialSettingYazFlexPage();
  }
}
