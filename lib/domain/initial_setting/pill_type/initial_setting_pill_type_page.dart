import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/pill_type/card_layout.dart';
import 'package:pilll/domain/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_type.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/link_account_type.dart';

class InitialSettingPillTypePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStoreProvider.notifier);
    final state = ref.watch(initialSettingStoreProvider);
    final authStream = ref.watch(authStateStreamProvider);

    useEffect(() {
      store.fetch();
      return null;
    }, [authStream]);

    useEffect(() {
      if (state.userIsNotAnonymous) {
        final accountType = state.accountType;
        if (accountType != null) {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text("${accountType.providerName}でログインしました"),
              ),
            );
          });
        }

        if (state.settingIsExist) {
          AppRouter.signinAccount(context);
        }
      }

      return null;
    }, [state.userIsNotAnonymous, state.accountType, state.settingIsExist]);

    return HUD(
      shown: state.isLoading,
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          title: const Text(
            "1/3",
            style: TextStyle(color: TextColor.black),
          ),
          backgroundColor: PilllColors.white,
        ),
        body: SafeArea(
          child: Container(
            child: Row(
              children: [
                Column(
                  children: [
                    CardLayout(
                      pillType: PillType.pill_type_yaz_flex,
                      caption: "連続",
                      image: SvgPicture.asset("images/pill_type_yaz_flex.svg"),
                      name: "最長120日間",
                      pillNames: [
                        "ヤーズフレックス",
                      ],
                    ),
                    CardLayout(
                      pillType: PillType.pill_type_21_rest_7,
                      caption: "周期",
                      image: SvgPicture.asset("images/pill_type_21_rest_7.svg"),
                      name: "21錠＋7日休薬",
                      pillNames: [
                        "ルナベル",
                        "フルウェル",
                        "マーベロン21",
                        "ラベルフィーユ21",
                        "アンジュ21",
                        "ジェミーナ"
                      ],
                    ),
                    CardLayout(
                      pillType: PillType.pill_type_21_rest_7,
                      caption: "周期",
                      image: SvgPicture.asset("images/pill_type_24_rest_4.svg"),
                      name: "24錠＋4偽薬",
                      pillNames: [
                        "ヤーズ",
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    CardLayout(
                      pillType: PillType.pill_type_jemina,
                      caption: "連続",
                      image: SvgPicture.asset("images/pill_type_jemina.svg"),
                      name: "77日+7日休薬",
                      pillNames: [
                        "ジェミーナ",
                      ],
                    ),
                    CardLayout(
                      pillType: PillType.pill_type_24_rest_4,
                      caption: "周期",
                      image: SvgPicture.asset("images/pill_type_24_rest_4.svg"),
                      name: "24日+4日休薬",
                      pillNames: [
                        "ヤーズフレックス",
                      ],
                    ),
                    CardLayout(
                      pillType: PillType.pill_type_21_fake_7,
                      caption: "周期",
                      image: SvgPicture.asset("images/pill_type_21_fake_7.svg"),
                      name: "21錠＋7偽薬",
                      pillNames: [
                        "マーベロン28",
                        "トリキュラー28",
                        "ラベルフィーユ28",
                        "アンジュ28",
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
