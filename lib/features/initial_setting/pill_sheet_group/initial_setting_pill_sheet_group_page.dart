import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/features/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';
import 'package:pilll/utils/router.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

class InitialSettingPillSheetGroupPage extends HookConsumerWidget {
  const InitialSettingPillSheetGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    final user = ref.watch(userProvider);
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    final didEndInitialSettingNotifier = ref.watch(boolSharedPreferencesProvider(BoolKey.didEndInitialSetting).notifier);
    final userIsAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous == true;

    // For linked user
    useEffect(() {
      if (userIsAnonymous) {
        analytics.logEvent(name: "initial_setting_signin_account", parameters: {"uid": FirebaseAuth.instance.currentUser?.uid});

        final LinkAccountType? accountType = () {
          if (isAppleLinked) {
            return LinkAccountType.apple;
          } else if (isGoogleLinked) {
            return LinkAccountType.google;
          } else {
            return null;
          }
        }();
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
      }

      return null;
    }, [isAppleLinked, isGoogleLinked]);

    // Skip initial setting when user already set setting.
    final navigator = Navigator.of(context);
    useEffect(() {
      void f() async {
        if (user.asData?.value.setting != null) {
          await AppRouter.endInitialSetting(navigator, didEndInitialSettingNotifier);
        }
      }

      f();
      return null;
    }, [user]);

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
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "処方されるシートについて\n教えてください",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: TextColor.main,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      InitialSettingPillSheetGroupPageBody(state: state, store: store),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: PilllColors.background,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.pillSheetTypeInfos.isNotEmpty)
                          SizedBox(
                            width: 180,
                            child: PrimaryButton(
                              text: "次へ",
                              onPressed: () async {
                                analytics.logEvent(name: "next_to_today_pill_number");
                                Navigator.of(context).push(InitialSettingSelectTodayPillNumberPageRoute.route());
                              },
                            ),
                          ),
                        if (userIsAnonymous) ...[
                          const SizedBox(height: 20),
                          AlertButton(
                            text: "すでにアカウントをお持ちの方はこちら",
                            onPressed: () async {
                              analytics.logEvent(name: "pressed_initial_setting_signin");
                              showSignInSheet(
                                context,
                                SignInSheetStateContext.initialSetting,
                                (accountType) async {
                                  store.showHUD();
                                },
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InitialSettingPillSheetGroupPageBody extends StatelessWidget {
  const InitialSettingPillSheetGroupPageBody({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  final InitialSettingState state;
  final InitialSettingStateNotifier store;

  @override
  Widget build(BuildContext context) {
    if (state.pillSheetTypeInfos.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            SvgPicture.asset("images/empty_pill_sheet_type.svg"),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                  onPressed: () async {
                    analytics.logEvent(name: "empty_pill_sheet_type");
                    showSettingPillSheetGroupSelectPillSheetTypePage(
                      context: context,
                      pillSheetType: null,
                      onSelect: (pillSheetType) {
                        store.selectedFirstPillSheetType(pillSheetType);
                      },
                    );
                  },
                  text: "ピルの種類を選ぶ"),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 6),
          SettingPillSheetGroup(
              pillSheetTypes: state.pillSheetTypeInfos,
              onAdd: (pillSheetType) {
                analytics.logEvent(name: "initial_setting_add_pill_sheet_group", parameters: {"pill_sheet_type": pillSheetType.fullName});
                store.addPillSheetType(pillSheetType);
              },
              onChange: (index, pillSheetType) {
                analytics.logEvent(
                    name: "initial_setting_change_pill_sheet_group", parameters: {"index": index, "pill_sheet_type": pillSheetType.fullName});
                store.changePillSheetType(index, pillSheetType);
              },
              onDelete: (index) {
                analytics.logEvent(name: "initial_setting_delete_pill_sheet_group", parameters: {"index": index});
                store.removePillSheetType(index);
              }),
        ],
      );
    }
  }
}

extension InitialSettingPillSheetGroupPageRoute on InitialSettingPillSheetGroupPage {
  static InitialSettingPillSheetGroupPage screen() {
    analytics.setCurrentScreen(screenName: "InitialSettingPillSheetGroupPage");
    return const InitialSettingPillSheetGroupPage();
  }
}
