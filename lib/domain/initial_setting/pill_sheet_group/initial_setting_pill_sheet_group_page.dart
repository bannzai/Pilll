import 'package:flutter_svg/svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/today_pill_number/initial_setting_select_today_pill_number_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class InitialSettingPillSheetGroupPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStoreProvider.notifier);
    final state = ref.watch(initialSettingStoreProvider);

    return HUD(
      shown: state.isLoading,
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "2/4",
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
                      Text(
                        "処方されるピルについて\n教えてください",
                        style: FontType.sBigTitle.merge(TextColorStyle.main),
                        textAlign: TextAlign.center,
                      ),
                      InitialSettingPillSheetGroupPageBody(
                          state: state, store: store),
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
                        if (state.pillSheetTypes.isNotEmpty)
                          PrimaryButton(
                            text: "次へ",
                            onPressed: () async {
                              analytics.logEvent(
                                  name: "next_to_today_pill_number");
                              Navigator.of(context).push(
                                  InitialSettingSelectTodayPillNumberPageRoute
                                      .route());
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
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  final InitialSettingState state;
  final InitialSettingStateStore store;

  @override
  Widget build(BuildContext context) {
    if (state.pillSheetTypes.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            SvgPicture.asset("images/empty_pill_sheet_type.svg"),
            const SizedBox(height: 24),
            PrimaryButton(
                onPressed: () async {
                  analytics.logEvent(name: "empty_pill_sheet_type");
                  showSettingPillSheetGroupSelectPillSheetTypePage(
                    context: context,
                    pillSheetType: null,
                    onSelect: (pillSheetType) {
                      store.addPillSheetType(pillSheetType);
                    },
                  );
                },
                text: "ピルの種類を選ぶ"),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 6),
          SettingPillSheetGroup(
              pillSheetTypes: state.pillSheetTypes,
              onAdd: (pillSheetType) {
                analytics.logEvent(
                    name: "initial_setting_add_pill_sheet_group",
                    parameters: {"pill_sheet_type": pillSheetType.fullName});
                store.addPillSheetType(pillSheetType);
              },
              onChange: (index, pillSheetType) {
                analytics.logEvent(
                    name: "initial_setting_change_pill_sheet_group",
                    parameters: {
                      "index": index,
                      "pill_sheet_type": pillSheetType.fullName
                    });
                store.changePillSheetType(index, pillSheetType);
              },
              onDelete: (index) {
                analytics.logEvent(
                    name: "initial_setting_delete_pill_sheet_group",
                    parameters: {"index": index});
                store.removePillSheetType(index);
              }),
        ],
      );
    }
  }
}

extension InitialSettingPillSheetGroupPageRoute
    on InitialSettingPillSheetGroupPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "InitialSettingPillSheetGroupPage"),
      builder: (_) => InitialSettingPillSheetGroupPage(),
    );
  }
}
