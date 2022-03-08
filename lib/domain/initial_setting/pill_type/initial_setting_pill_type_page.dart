import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/initial_setting/pill_type/card_layout.dart';
import 'package:pilll/domain/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/entity/initial_setting_pill_category_type.dart';
import 'package:pilll/router/router.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

const initialSettingPillCategoryUserPropertyName = "i_s_pill_category";

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
          child: SizedBox.expand(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // onbording_1
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Frame 5008
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "服用しているピルの種類は？",
                                style: TextStyle(
                                  color: TextColor.main,
                                  fontSize: 16,
                                  fontFamily: FontFamily.japanese,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              // Frame 5007
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CardLayout(
                                          pillType:
                                              InitialSettingPillCategoryType
                                                  .pill_category_type_yaz_flex,
                                          caption: "連続",
                                          image: SvgPicture.asset(
                                              "images/pill_category_type_yaz_flex.svg"),
                                          name: "最長120日間",
                                          pillNames: [
                                            "ヤーズフレックス",
                                          ],
                                          onTap: (pillType) {
                                            analytics.logEvent(
                                                name:
                                                    "i_s_pill_c_t_yaz_flex_card_tap");
                                            analytics.setUserProperties(
                                                initialSettingPillCategoryUserPropertyName,
                                                "pill_category_type_yaz_flex");

                                            store.selectedPillType(pillType);
                                            Navigator.of(context).push(
                                                InitialSettingSelectTodayPillNumberPageRoute
                                                    .route());
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        CardLayout(
                                          pillType:
                                              InitialSettingPillCategoryType
                                                  .pill_category_type_21_rest_7,
                                          caption: "周期",
                                          image: SvgPicture.asset(
                                              "images/pill_category_type_21_rest_7.svg"),
                                          name: "21錠＋7日休薬",
                                          pillNames: [
                                            "ルナベル",
                                            "フルウェル",
                                            "マーベロン21",
                                            "ラベルフィーユ21",
                                            "アンジュ21",
                                            "ジェミーナ"
                                          ],
                                          onTap: (pillType) {
                                            analytics.logEvent(
                                                name:
                                                    "i_s_pill_c_t_21_rest_7_card_tap");
                                            analytics.setUserProperties(
                                                initialSettingPillCategoryUserPropertyName,
                                                "pill_category_type_21_rest_7");

                                            store.selectedPillType(pillType);
                                            Navigator.of(context).push(
                                                InitialSettingPillSheetGroupPageRoute
                                                    .route());
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        CardLayout(
                                          pillType:
                                              InitialSettingPillCategoryType
                                                  .pill_category_type_24_fake_4,
                                          caption: "周期",
                                          image: SvgPicture.asset(
                                              "images/pill_category_type_24_fake_4.svg"),
                                          name: "24錠＋4偽薬",
                                          pillNames: [
                                            "ヤーズ",
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CardLayout(
                                          pillType:
                                              InitialSettingPillCategoryType
                                                  .pill_category_type_jemina,
                                          caption: "連続",
                                          image: SvgPicture.asset(
                                              "images/pill_category_type_jemina.svg"),
                                          name: "77日+7日休薬",
                                          pillNames: [
                                            "ジェミーナ",
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        CardLayout(
                                          pillType:
                                              InitialSettingPillCategoryType
                                                  .pill_category_type_24_rest_4,
                                          caption: "周期",
                                          image: SvgPicture.asset(
                                              "images/pill_category_type_24_rest_4.svg"),
                                          name: "24日+4日休薬",
                                          pillNames: [
                                            "ヤーズフレックス",
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        CardLayout(
                                          pillType:
                                              InitialSettingPillCategoryType
                                                  .pill_category_type_21_fake_7,
                                          caption: "周期",
                                          image: SvgPicture.asset(
                                              "images/pill_category_type_21_fake_7.svg"),
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!state.userIsNotAnonymous) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: PilllColors.background,
                      child: AlertButton(
                        text: "すでにアカウントをお持ちの方はこちら",
                        onPressed: () async {
                          analytics.logEvent(
                              name: "pressed_initial_setting_signin");
                          showSigninSheet(
                            context,
                            SigninSheetStateContext.initialSetting,
                            (accountType) async {
                              store.showHUD();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension InitialSettingPillTypePageRoute on InitialSettingPillTypePage {
  static InitialSettingPillTypePage screen() {
    analytics.setCurrentScreen(screenName: "InitialSettingPillTypePage");
    return InitialSettingPillTypePage();
  }
}
