import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/organisms/pill_sheet/add_pill_sheet_type_empty.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/features/initial_setting/today_pill_number/page.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';

class InitialSettingPillSheetGroupPage extends HookConsumerWidget {
  const InitialSettingPillSheetGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);

    // For linked user
    useEffect(() {
      analytics.logEvent(name: 'initial_setting_signin_account', parameters: {'uid': FirebaseAuth.instance.currentUser?.uid});

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
              content: Text(L.loggedInWithProvider(accountType.providerName)),
            ),
          );
        });
      }

      return null;
    }, [isAppleLinked, isGoogleLinked]);

    return HUD(
      shown: state.isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            '1/3',
            style: TextStyle(color: TextColor.black),
          ),
          backgroundColor: AppColors.white,
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
                      Text(
                        L.tellAboutPrescribedSheet,
                        style: const TextStyle(
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
                    color: AppColors.background,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.pillSheetTypes.isNotEmpty)
                          SizedBox(
                            width: 180,
                            child: PrimaryButton(
                              text: L.next,
                              onPressed: () async {
                                analytics.logEvent(name: 'next_to_today_pill_number');
                                Navigator.of(context).push(InitialSettingSelectTodayPillNumberPageRoute.route());
                              },
                            ),
                          ),
                        const SizedBox(height: 20),
                        AlertButton(
                          text: L.existingAccountUsers,
                          onPressed: () async {
                            analytics.logEvent(name: 'pressed_initial_setting_signin');
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
    super.key,
    required this.state,
    required this.store,
  });

  final InitialSettingState state;
  final InitialSettingStateNotifier store;

  @override
  Widget build(BuildContext context) {
    if (state.pillSheetTypes.isEmpty) {
      return AddPillSheetTypeEmpty(onSelect: (pillSheetType) => store.selectedFirstPillSheetType(pillSheetType));
    } else {
      return Column(
        children: [
          const SizedBox(height: 6),
          SettingPillSheetGroup(
              pillSheetTypes: state.pillSheetTypes,
              onAdd: (pillSheetType) {
                analytics.logEvent(name: 'initial_setting_add_pill_sheet_group', parameters: {'pill_sheet_type': pillSheetType.fullName});
                store.addPillSheetType(pillSheetType);
              },
              onChange: (index, pillSheetType) {
                analytics.logEvent(
                    name: 'initial_setting_change_pill_sheet_group', parameters: {'index': index, 'pill_sheet_type': pillSheetType.fullName});
                store.changePillSheetType(index, pillSheetType);
              },
              onDelete: (index) {
                analytics.logEvent(name: 'initial_setting_delete_pill_sheet_group', parameters: {'index': index});
                store.removePillSheetType(index);
              }),
        ],
      );
    }
  }
}

extension InitialSettingPillSheetGroupPageRoute on InitialSettingPillSheetGroupPage {
  static InitialSettingPillSheetGroupPage screen() {
    analytics.setCurrentScreen(screenName: 'InitialSettingPillSheetGroupPage');
    return const InitialSettingPillSheetGroupPage();
  }
}
